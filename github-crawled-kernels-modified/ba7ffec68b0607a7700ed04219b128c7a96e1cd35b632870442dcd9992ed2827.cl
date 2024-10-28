//{"ret":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_global_linear_id(global int* ret) {
  int id = get_global_linear_id();
  ret[hook(0, id)] = id;
}