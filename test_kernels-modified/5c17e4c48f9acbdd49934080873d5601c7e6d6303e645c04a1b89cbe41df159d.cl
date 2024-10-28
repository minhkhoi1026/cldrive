//{"coeff":1,"res":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiply_by_scalar(global float const* const src, private float const coeff, global float* const res) {
  unsigned int const idx = get_global_id(0);

  res[hook(2, idx)] = src[hook(0, idx)] * coeff;
}