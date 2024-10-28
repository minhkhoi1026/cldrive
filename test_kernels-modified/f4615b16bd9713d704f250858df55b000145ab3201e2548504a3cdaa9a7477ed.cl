//{"alpha":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) __attribute__((reqd_work_group_size(256, 1, 1))) kernel void scal(const float alpha, global float* x) {
  unsigned int gid = get_global_id(0);
  x[hook(1, gid)] = alpha * x[hook(1, gid)];
}