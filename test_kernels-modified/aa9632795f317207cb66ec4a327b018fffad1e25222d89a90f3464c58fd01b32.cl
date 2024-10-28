//{"ioim":0,"threshold":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxThreshold(global float* ioim, float threshold) {
  const int index = get_global_id(0);
  if (isnan(ioim[hook(0, index)]) || ioim[hook(0, index)] < threshold)
    return;
  ioim[hook(0, index)] = __builtin_astype((2147483647), float);
}