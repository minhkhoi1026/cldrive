//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void taskParallelSub(global float* A, global float* B, global float* C) {
  int base = 1;

  C[hook(2, base + 0)] = A[hook(0, base + 0)] - B[hook(1, base + 0)];
  C[hook(2, base + 4)] = A[hook(0, base + 4)] - B[hook(1, base + 4)];
  C[hook(2, base + 8)] = A[hook(0, base + 8)] - B[hook(1, base + 8)];
  C[hook(2, base + 12)] = A[hook(0, base + 12)] - B[hook(1, base + 12)];
}