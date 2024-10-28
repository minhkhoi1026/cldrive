//{"foo":2,"s1":0,"s2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void simple(global int* restrict s1, global const int* s2, int foo) {
  const int id = get_global_id(0);
  s1[hook(0, id)] = s2[hook(1, id)] + id * foo;
}