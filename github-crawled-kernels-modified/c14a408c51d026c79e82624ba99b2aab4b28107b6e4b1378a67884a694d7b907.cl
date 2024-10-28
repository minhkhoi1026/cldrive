//{"c":1,"g":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float* g, constant float* c) {
  __builtin_memcpy(g, c, 32);
}