//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sample(global float* A, global float* B, global float* C) {
  int base = 4 * get_global_id(0);

  C[hook(2, base + 0)] = A[hook(0, base + 0)] + B[hook(1, base + 0)];
  C[hook(2, base + 1)] = A[hook(0, base + 1)] - B[hook(1, base + 1)];
  C[hook(2, base + 2)] = A[hook(0, base + 2)] * B[hook(1, base + 2)];
  C[hook(2, base + 3)] = A[hook(0, base + 3)] / B[hook(1, base + 3)];
}