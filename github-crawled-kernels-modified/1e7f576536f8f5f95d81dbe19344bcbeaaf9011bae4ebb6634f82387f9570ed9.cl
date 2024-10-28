//{"i_dim":1,"ret":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void builtin_local_size(global int* ret, global int* i_dim) {
  *ret = get_local_size(*i_dim);
}