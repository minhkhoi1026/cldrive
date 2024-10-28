//{"A":0,"B":1,"K":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test3(global float* A, global float* B, float K) {
  for (int i = 0; i < 800; ++i)
    A[hook(0, i)] *= B[hook(1, i)] + K;
}