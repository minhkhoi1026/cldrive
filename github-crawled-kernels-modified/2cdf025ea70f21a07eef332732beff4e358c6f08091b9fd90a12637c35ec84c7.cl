//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecadd(global const float* A, global const float* B, global float* C) {
  int id = get_global_id(0);
  C[hook(2, id)] = A[hook(0, id)] + B[hook(1, id)];
}