//{"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void closerLaserScanDouble(global double* v) {
  unsigned int i = get_global_id(0);
  v[hook(0, i)] = v[hook(0, i)] * v[hook(0, i)] * 0.1f;
}