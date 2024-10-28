//{"a_g":0,"b_g":1,"res_g":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global const double* a_g, global const double* b_g, global double* res_g) {
  int gid = get_global_id(0);
  res_g[hook(2, gid)] = a_g[hook(0, gid)] + b_g[hook(1, gid)];
}