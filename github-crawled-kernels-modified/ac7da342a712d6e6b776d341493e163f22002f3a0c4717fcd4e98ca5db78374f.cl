//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test8(global int* A, global int* B) {
  for (int i = 0; i < 1024; ++i)
    A[hook(0, i)] += B[hook(1, i * 4)];
}