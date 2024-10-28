//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(const global float* A, const global float* B, global float* C) {
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);

  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);
  barrier(0x01);

  C[hook(2, 0)] += A[hook(0, 0)] * B[hook(1, 0)];
  C[hook(2, 1)] += A[hook(0, 1)] * B[hook(1, 1)];
}