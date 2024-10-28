//{"in1":1,"num":0,"out":3,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_divide_scalar_matx(const int num, global const float* in1, const float x, global float* out) {
  const int i = get_global_id(0);
  if (i >= num)
    return;
  out[hook(3, i)] = in1[hook(1, i)] / x;
}