//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void bar() {
}

kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo() {
  bar();
}