//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float* in, global float* out) {
  int i = get_global_id(0);
  printf("%f %f ", in[hook(0, i)], *(out + 4 - i));
}