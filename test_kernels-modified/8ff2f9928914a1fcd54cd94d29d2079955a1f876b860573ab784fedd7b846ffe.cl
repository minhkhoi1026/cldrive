//{"data":0,"g_counter":2,"groupnum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arithm_op_minMax_final(global float* data, int groupnum, global int* g_counter) {
  g_counter[hook(2, 0)] = 0;
  float minVal = data[hook(0, 0)];
  float maxVal = data[hook(0, groupnum)];
  for (int i = 1; i < groupnum; ++i) {
    minVal = min(minVal, data[hook(0, i)]);
    maxVal = max(maxVal, data[hook(0, i + groupnum)]);
  }
  data[hook(0, 0)] = minVal;
  data[hook(0, 1)] = maxVal;
}