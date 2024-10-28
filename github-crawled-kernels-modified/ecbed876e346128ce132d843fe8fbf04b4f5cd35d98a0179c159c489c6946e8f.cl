//{"A":0,"C":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyKernel1(global const double* restrict A, global double* restrict C) {
  size_t tid = get_global_id(0);

  C[hook(1, tid)] = A[hook(0, tid)];
}