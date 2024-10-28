//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fadd(global float* A, global float* B, global float* C) {
  int gid = get_global_id(0);
  C[hook(2, gid)] = A[hook(0, gid)] + B[hook(1, gid)];
}