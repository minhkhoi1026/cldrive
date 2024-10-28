//{"adjs_array":1,"factor":4,"nels":3,"result_vertex4_array":2,"vertex4_array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth(global const float4* restrict vertex4_array, global const unsigned int* restrict adjs_array, global float4* restrict result_vertex4_array, unsigned int nels, float factor) {
  const unsigned int i = get_global_id(0);
  if (i >= nels)
    return;

  const float4 vertex = vertex4_array[hook(0, i)];

  const float lastComponent = vertex.w;
  const unsigned int adjsInfo = __builtin_astype((lastComponent), unsigned int);
  const unsigned int adjsIndexOffset = adjsInfo >> 6;
  const unsigned int adjsCount = (adjsInfo & 0x3f);

  float4 current_adj, umbrellaOperator = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  for (int adjIndex = 0; adjIndex < adjsCount; adjIndex++) {
    current_adj = vertex4_array[hook(0, adjs_array[ahook(1, adjsIndexOffset + adjIndex))];
    umbrellaOperator += (current_adj - vertex);
  }

  umbrellaOperator /= adjsCount;
  float4 res = vertex + factor * umbrellaOperator;
  res.w = lastComponent;
  result_vertex4_array[hook(2, i)] = res;
}