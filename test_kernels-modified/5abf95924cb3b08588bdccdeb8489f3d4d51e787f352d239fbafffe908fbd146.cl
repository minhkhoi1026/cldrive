//{"high":2,"in":3,"low":1,"num":0,"out":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_clamp(const int num, float low, float high, global const float* in, global float* out) {
  const int i = get_global_id(0);
  if (i >= num)
    return;
  out[hook(4, i)] = clamp(in[hook(3, i)], low, high);
}