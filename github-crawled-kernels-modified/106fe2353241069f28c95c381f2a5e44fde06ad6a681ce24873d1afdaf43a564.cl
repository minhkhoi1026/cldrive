//{"coeff":0,"res":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiply_by_scalar(private float coeff, global float* src, global float* res) {
  unsigned int const idx = get_global_id(0);
  res[hook(2, idx)] = src[hook(1, idx)] * coeff;
}