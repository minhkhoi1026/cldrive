//{"bar":1,"foo":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_store_double(double foo, global float* bar) {
  __builtin_store_half(foo, bar);
}