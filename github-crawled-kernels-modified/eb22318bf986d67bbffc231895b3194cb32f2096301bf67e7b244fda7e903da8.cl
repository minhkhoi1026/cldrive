//{"m1":0,"m2":1,"mr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void arrayMultiply(global const float* m1, global const float* m2, global float* mr) {
  int iGID = get_global_id(0);
  mr[hook(2, iGID)] = m1[hook(0, iGID)] * m2[hook(1, iGID)];
}