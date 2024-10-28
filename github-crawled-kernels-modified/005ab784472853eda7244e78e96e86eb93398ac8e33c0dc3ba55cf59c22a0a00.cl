//{"ret":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_local_id(global int* ret) {
  int id = get_local_id(0) + get_group_id(0) * 2 + get_local_id(1) * 4 + get_group_id(1) * 12 + get_local_id(2) * 36 + get_group_id(2) * 144;

  ret[hook(0, id)] = id;
}