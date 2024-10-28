//{"compare":1,"ptr":0,"val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_atomic_cmpxchg(global unsigned* ptr, unsigned compare, unsigned val) {
  atomic_cmpxchg(ptr, compare, val);
}