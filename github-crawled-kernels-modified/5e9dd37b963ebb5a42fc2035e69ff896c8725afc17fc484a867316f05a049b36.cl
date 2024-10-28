//{"pData":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void relu_layer(global float* pData) {
  const int x = get_global_id(0);
  float zero = 0.0;
  pData[hook(0, x)] = fmax(zero, pData[hook(0, x)]);
}