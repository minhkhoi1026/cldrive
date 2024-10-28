//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addKernel16(global const double16* restrict A, global const double16* restrict B, global double16* restrict C) {
  size_t tid = get_global_id(0);

  C[hook(2, tid)] = A[hook(0, tid)] + B[hook(1, tid)];
}