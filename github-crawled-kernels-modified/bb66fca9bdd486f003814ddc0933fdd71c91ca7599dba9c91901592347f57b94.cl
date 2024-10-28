//{"in1":2,"num":0,"out":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_divide_scalar_xmat(const int num, const float x, global const float* in1, global float* out) {
  const int i = get_global_id(0);
  if (i >= num)
    return;
  out[hook(3, i)] = x / in1[hook(2, i)];
}