//{"in":1,"num":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_fabs(const int num, global const float* in, global float* out) {
  const int i = get_global_id(0);
  if (i >= num)
    return;
  out[hook(2, i)] = fabs(in[hook(1, i)]);
}