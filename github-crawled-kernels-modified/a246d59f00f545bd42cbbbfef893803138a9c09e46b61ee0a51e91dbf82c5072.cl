//{"ret":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buildin_work_dim(global int* ret) {
  *ret = get_work_dim();
}