//{"A":0,"C":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyKernel16(global const double16* restrict A, global double16* restrict C) {
  size_t tid = get_global_id(0);

  C[hook(1, tid)] = A[hook(0, tid)];
}