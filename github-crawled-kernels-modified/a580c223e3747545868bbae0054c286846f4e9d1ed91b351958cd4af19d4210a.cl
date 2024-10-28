//{"Y":1,"dX":0,"dY":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void NL_SIGM_BWD(global float* dX, global float* Y, global float* dY) {
  unsigned int element = get_global_id(0);
  const float Y_value = Y[hook(1, element)];
  const float dY_value = dY[hook(2, element)];
  dX[hook(0, element)] = dY_value * Y_value * (1.0 - Y_value);
}