//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test6(global int* A, global int* B) {
  unsigned sum = 0;

  for (int i = 0; i < 1024; ++i)
    if (A[hook(0, i)] > B[hook(1, i)])
      sum += A[hook(0, i)] + 5;
  *B = sum;
}