//{"A":0,"B":2,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void apple(global int* B, global int* A, int n) {
  A[hook(0, n)] = B[hook(2, n + 2)];
}

kernel void bar(global int* A, int n, global int* B) {
  apple(B, A, n);
}