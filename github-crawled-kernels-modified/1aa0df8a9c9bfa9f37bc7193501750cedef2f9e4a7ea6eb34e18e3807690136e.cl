//{"multiplier":1,"output":0,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scale_f(global float* output, const float multiplier, const unsigned int size) {
  unsigned int tid = get_global_id(0);

  if (tid < size)
    output[hook(0, tid)] = output[hook(0, tid)] * multiplier;
}