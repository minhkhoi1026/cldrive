//{"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(256, 1, 1))) kernel void swp(global float* x, global float* y) {
  unsigned int gid = get_global_id(0);
  float temp = x[hook(0, gid)];
  x[hook(0, gid)] = y[hook(1, gid)];
  y[hook(1, gid)] = temp;
}