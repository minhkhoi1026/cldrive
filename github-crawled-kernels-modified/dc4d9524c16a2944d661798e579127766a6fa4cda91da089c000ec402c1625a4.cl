//{"multiplier":3,"output":0,"size":4,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scaled_sum_three_s_d(global double* output, global double* x, global double* y, const double multiplier, const unsigned int size) {
  unsigned int tid = get_global_id(0);

  if (tid < size)
    output[hook(0, tid)] = x[hook(1, tid)] + y[hook(2, tid)] * multiplier;
}