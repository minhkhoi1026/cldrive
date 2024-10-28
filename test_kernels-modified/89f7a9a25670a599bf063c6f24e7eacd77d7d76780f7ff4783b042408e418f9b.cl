//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int b[4] = {42, 13, 0, 5};

unsigned int bar(constant unsigned int* a) {
  return a[hook(0, get_local_id(0))];
}

kernel void __attribute__((reqd_work_group_size(4, 1, 1))) foo(global unsigned int* a) {
  *a = bar(b);
}