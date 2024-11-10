//{"output":0,"size":3,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void difference_three_d(global double* output, global const double* x, global const double* y, const unsigned int size) {
  unsigned int tid = get_global_id(0);

  if (tid < size)
    output[hook(0, tid)] = x[hook(1, tid)] - y[hook(2, tid)];
}