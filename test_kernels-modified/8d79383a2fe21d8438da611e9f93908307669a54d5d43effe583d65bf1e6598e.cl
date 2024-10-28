//{"k":0,"m":1,"mr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scalarDivide(float k, global const float* m, global float* mr) {
  int iGID = get_global_id(0);
  mr[hook(2, iGID)] = k / m[hook(1, iGID)];
}