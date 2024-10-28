//{"output":0,"size":3,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scaled_sum_three_f(global float* output, global float* x, global float* y, const unsigned int size) {
  unsigned int tid = get_global_id(0);

  if (tid < size)
    output[hook(0, tid)] = output[hook(0, tid)] + x[hook(1, tid)] * y[hook(2, tid)];
}