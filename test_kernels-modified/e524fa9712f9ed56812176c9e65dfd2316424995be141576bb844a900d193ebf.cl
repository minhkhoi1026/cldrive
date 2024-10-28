//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_add_adjust(global int* A, global const int* B) {
  int id = get_global_id(0);
  int gid = get_group_id(0);
  A[hook(0, id)] += B[hook(1, gid)];
}