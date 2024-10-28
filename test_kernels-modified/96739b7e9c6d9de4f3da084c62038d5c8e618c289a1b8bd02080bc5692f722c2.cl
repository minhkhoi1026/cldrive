//{"adjs_array":2,"factor":5,"local_vertex_array":1,"nels":4,"result_vertex4_array":3,"vertex4_array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth_lmem_wide(global const float4* restrict vertex4_array, local float* restrict local_vertex_array, global const unsigned int* restrict adjs_array, global float4* restrict result_vertex4_array, unsigned int nels, float factor) {
  const unsigned int i = get_global_id(0);

  const unsigned int li = get_local_id(0);
  const unsigned int ls = get_local_size(0);
  const unsigned int gi = get_group_id(0);
  const unsigned int GIxLS = gi * ls;

  const int tmp = i - ls;
  if (tmp >= 0)
    vstore3(vertex4_array[hook(0, i - ls)].xyz, li, local_vertex_array);

  if (i >= nels)
    return;

  const float4 vertex = vertex4_array[hook(0, i)];
  vstore3(vertex.xyz, (li + ls), local_vertex_array);

  if (i + ls < nels)
    vstore3(vertex4_array[hook(0, i + ls)].xyz, (li + 2 * ls), local_vertex_array);

  barrier(0x01);

  const float lastComponent = vertex.w;
  const unsigned int adjsInfo = __builtin_astype((lastComponent), unsigned int);
  const unsigned int adjsIndexOffset = adjsInfo >> 6;
  const unsigned int adjsCount = (adjsInfo & 0x3f);

  float4 current_adj, umbrellaOperator = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float3 tmp_vector;
  unsigned int adj_index;
  int local_Adjindex;
  const int limit = 2 * ls;
  for (int adjIndex = 0; adjIndex < adjsCount; adjIndex++) {
    adj_index = adjs_array[hook(2, adjsIndexOffset + adjIndex)];
    local_Adjindex = adj_index - GIxLS;

    if (local_Adjindex >= -ls && local_Adjindex < limit) {
      tmp_vector = vload3(local_Adjindex + ls, local_vertex_array);
      current_adj = (float4)(tmp_vector.x, tmp_vector.y, tmp_vector.z, 0.0f);
    } else {
      current_adj = vertex4_array[hook(0, adj_index)];
    }
    umbrellaOperator += (current_adj - vertex);
  }

  umbrellaOperator /= adjsCount;
  float4 res = vertex + factor * umbrellaOperator;
  res.w = lastComponent;

  result_vertex4_array[hook(3, i)] = res;
}