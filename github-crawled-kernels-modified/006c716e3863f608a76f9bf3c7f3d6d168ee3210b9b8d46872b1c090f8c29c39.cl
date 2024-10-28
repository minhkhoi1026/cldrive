//{"A":0,"B":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void apple(global int* A, global int* B, int n) {
  A[hook(0, n)] = B[hook(1, n + 2)];
}

kernel void foo(global int* A, global int* B, int n) {
  apple(A, B, n);
}