//{"adjsCounter_array":2,"adjs_array":1,"factor":5,"nels":4,"result_vertex4_array":3,"vertex4_array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth_coalescence(global const float4* restrict vertex4_array, global const unsigned int* restrict adjs_array, global const unsigned int* restrict adjsCounter_array, global float4* restrict result_vertex4_array, unsigned int nels, float factor) {
  const unsigned int i = get_global_id(0);
  if (i >= nels)
    return;

  const float4 vertex = vertex4_array[hook(0, i)];
  const float lastComponent = vertex.w;
  const unsigned int adjsCount = __builtin_astype((lastComponent), unsigned int);

  float4 current_adj;
  float4 umbrellaOperator = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  int offset = 0;
  for (int adjIndex = 0; adjIndex < adjsCount; adjIndex++) {
    current_adj = vertex4_array[hook(0, adjs_array[ihook(1, i + offset))];
    umbrellaOperator += (current_adj - vertex);
    offset += adjsCounter_array[hook(2, adjIndex)];
  }

  umbrellaOperator /= adjsCount;
  float4 res = vertex + factor * umbrellaOperator;
  res.w = lastComponent;
  result_vertex4_array[hook(3, i)] = res;
}