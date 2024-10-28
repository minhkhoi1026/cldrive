//{"dot":2,"n":3,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _dot_opencl(global float* x, global float* y, global double* dot, unsigned n) {
  unsigned i;
  local double tmp;
  tmp = 0.0;
  for (i = 0; i < n; i++)
    tmp += x[hook(0, i)] * y[hook(1, i)];

  *dot += tmp;
}