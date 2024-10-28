//{"num":0,"out":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_scale(const int num, float x, global float* out) {
  const int i = get_global_id(0);
  if (i >= num)
    return;
  out[hook(2, i)] = x * out[hook(2, i)];
}