//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size(8, 1, 1))) void kernel2(global int* x) {
  x[hook(0, get_global_id(0))] = 0;
}

kernel void __attribute__((reqd_work_group_size(16, 1, 1))) kernel3(global int* x) {
  x[hook(0, get_global_id(0))] = 1;
}