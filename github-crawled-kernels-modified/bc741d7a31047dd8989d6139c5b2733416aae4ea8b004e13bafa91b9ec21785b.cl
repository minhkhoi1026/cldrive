//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addKernel1(global const double* restrict A, global const double* restrict B, global double* restrict C) {
  size_t tid = get_global_id(0);

  C[hook(2, tid)] = A[hook(0, tid)] + B[hook(1, tid)];
}