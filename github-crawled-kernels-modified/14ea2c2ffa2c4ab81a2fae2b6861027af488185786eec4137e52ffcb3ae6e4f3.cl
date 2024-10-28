//{"a":0,"b":1,"c":2,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int do_sum(unsigned int a, unsigned int b, unsigned int c);
kernel void test_sum(global const unsigned int* a, global const unsigned int* b, global unsigned int* c, unsigned int d) {
  int gid = get_global_id(0);

  c[hook(2, gid)] = do_sum(a[hook(0, gid)], b[hook(1, gid)], d);
}