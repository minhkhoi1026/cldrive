//{"factor":2,"nx":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_mult_opencl(unsigned int nx, global float* val, float factor) {
  const int i = get_global_id(0);
  if (i < nx) {
    val[hook(1, i)] = i + 0.1;
    val[hook(1, i)] *= factor;
  }
}