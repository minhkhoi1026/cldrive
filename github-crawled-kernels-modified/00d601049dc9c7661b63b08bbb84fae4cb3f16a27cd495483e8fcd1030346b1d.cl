//{"in1":1,"in2":2,"num":0,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_subtract(const int num, global const float* in1, global const float* in2, global float* out) {
  const int i = get_global_id(0);
  if (i >= num)
    return;
  out[hook(3, i)] = in1[hook(1, i)] - in2[hook(2, i)];
}