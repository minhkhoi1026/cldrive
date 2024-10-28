//{"a":0,"b":1,"c":2,"length":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) krnl_vadd(global int* a, global int* b, global int* c, const int length) {
  for (int i = 0; i < length; i++) {
    c[hook(2, i)] = a[hook(0, i)] + b[hook(1, i)];
  }

  return;
}