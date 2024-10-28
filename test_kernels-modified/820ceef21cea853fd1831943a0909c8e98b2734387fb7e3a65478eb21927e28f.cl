//{"factor":2,"nx":1,"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_mult_opencl(global float* val, int nx, float factor) {
  const int i = get_global_id(0);
  if (i < nx) {
    val[hook(0, i)] *= factor;
  }
}