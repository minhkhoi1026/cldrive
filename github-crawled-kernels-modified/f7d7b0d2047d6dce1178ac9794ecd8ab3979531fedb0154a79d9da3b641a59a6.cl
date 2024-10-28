//{"a":1,"b":2,"c":0,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectorAddKernel(global float* c, global float* a, global float* b, const unsigned int n) {
  size_t wid = get_global_id(0);

  if (wid < n)
    c[hook(0, wid)] = a[hook(1, wid)] + b[hook(2, wid)];
}