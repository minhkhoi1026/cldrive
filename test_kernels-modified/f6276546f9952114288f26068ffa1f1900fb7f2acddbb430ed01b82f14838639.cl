//{"alpha":3,"nx":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _axpy_opencl(global float* x, global float* y, unsigned nx, float alpha) {
  const int i = get_global_id(0);
  if (i < nx)
    y[hook(1, i)] = alpha * x[hook(0, i)] + y[hook(1, i)];
}