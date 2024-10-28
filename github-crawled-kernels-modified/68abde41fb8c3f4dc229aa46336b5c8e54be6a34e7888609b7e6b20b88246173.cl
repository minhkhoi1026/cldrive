//{"a0":0,"a1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy(global double* a0, global double* a1) {
  int i = get_global_id(0) + 1;
  int j = get_global_id(1) + 1;
  int k = get_global_id(2) + 1;
  int sz = get_global_size(0) + 2;
  a0[hook(0, i * sz * sz + j * sz + k)] = a1[hook(1, i * sz * sz + j * sz + k)];
}