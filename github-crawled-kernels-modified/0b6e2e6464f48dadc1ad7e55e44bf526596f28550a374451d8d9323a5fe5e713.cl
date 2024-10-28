//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectAddInt(global int* A, global int* B, global int* C) {
  int i = get_global_id(0);
  C[hook(2, i)] = A[hook(0, i)] + B[hook(1, i)];
}