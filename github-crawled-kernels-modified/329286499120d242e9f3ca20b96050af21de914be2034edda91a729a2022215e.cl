//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int b = 42;
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global unsigned int* a) {
  *a = b;
}