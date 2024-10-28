//{"in1":1,"in2":2,"num":0,"out":3,"scratch":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_dot(const int num, global const float* in1, global const float* in2, global float* out, local float* scratch) {
  const int i = get_global_id(0);
  if (i >= num)
    return;
  int offset = i << 2;
  scratch[hook(4, i)] = in1[hook(1, offset)] * in2[hook(2, offset)];
}