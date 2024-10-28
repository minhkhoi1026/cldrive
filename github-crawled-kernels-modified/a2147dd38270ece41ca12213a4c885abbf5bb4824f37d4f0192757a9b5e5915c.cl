//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct test {
  int a[128];
};

void boo(struct test byval) {
}

kernel void __attribute__((reqd_work_group_size(1, 2, 3))) foo(void) {
  struct test byval;
  boo(byval);
}