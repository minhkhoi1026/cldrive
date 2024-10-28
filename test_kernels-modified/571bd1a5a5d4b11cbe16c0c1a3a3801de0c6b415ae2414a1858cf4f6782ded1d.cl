//{"k":0,"px":2,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inplace_multiply_const_kernel(const float k, const unsigned size, global float* px) {
  const unsigned i = get_global_id(0);
  if (i < size)
    px[hook(2, i)] *= k;
}