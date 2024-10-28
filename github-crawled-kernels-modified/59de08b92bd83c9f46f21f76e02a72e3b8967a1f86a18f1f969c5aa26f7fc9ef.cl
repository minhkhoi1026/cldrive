//{"buff":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void opticalDense(global float* buff) {
  int gid = get_global_id(0);
  buff[hook(0, gid)] = -log1p(buff[hook(0, gid)]);
}