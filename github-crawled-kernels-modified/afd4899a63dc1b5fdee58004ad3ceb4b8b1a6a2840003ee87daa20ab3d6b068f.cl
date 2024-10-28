//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initialiseArraysKernel(global double* restrict A, global double* restrict B, global double* restrict C) {
  size_t tid = get_global_id(0);

  A[hook(0, tid)] = 1.0;
  B[hook(1, tid)] = 2.0;
  C[hook(2, tid)] = 0.0;
}