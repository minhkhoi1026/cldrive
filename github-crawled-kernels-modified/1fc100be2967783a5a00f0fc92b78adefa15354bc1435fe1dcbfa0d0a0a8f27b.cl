//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecadd(global int* A, global int* B, global int* C) {
  int idx = get_global_id(0);

  C[hook(2, idx)] = A[hook(0, idx)] + B[hook(1, idx)];
}