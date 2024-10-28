//{"N":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_float(global float* output, int N) {
  int i = get_global_id(0);

  output[hook(0, i)] = 1.f * i;
}