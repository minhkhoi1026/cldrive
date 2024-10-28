//{"ptr":0,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_atomic_or(global unsigned* ptr, unsigned val) {
  atomic_or(ptr, val);
}