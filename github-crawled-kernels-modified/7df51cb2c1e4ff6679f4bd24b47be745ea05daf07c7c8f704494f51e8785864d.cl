//{"k":1,"m":0,"mr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixScalarMultiply(global const float* m, float k, global float* mr) {
  int iGID = get_global_id(0);
  mr[hook(2, iGID)] = m[hook(0, iGID)] * k;
}