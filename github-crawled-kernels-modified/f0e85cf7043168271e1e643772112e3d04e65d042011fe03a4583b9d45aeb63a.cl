//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vaddSimple(global const float* A, global const float* B, global float* C) {
  C[hook(2, get_global_id(0))] = A[hook(0, get_global_id(0))] + B[hook(1, get_global_id(0))];
}