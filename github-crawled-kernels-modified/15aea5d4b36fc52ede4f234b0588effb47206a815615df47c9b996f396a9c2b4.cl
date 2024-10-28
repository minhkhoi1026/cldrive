//{"cmp":1,"p":0,"val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_atomic_cmpxchg(global int* p, int cmp, int val) {
  atomic_cmpxchg(p, cmp, val);

  global unsigned int* up = (global unsigned int*)p;
  unsigned int ucmp = (unsigned int)cmp;
  unsigned int uval = (unsigned int)val;
  atomic_cmpxchg(up, ucmp, uval);
}