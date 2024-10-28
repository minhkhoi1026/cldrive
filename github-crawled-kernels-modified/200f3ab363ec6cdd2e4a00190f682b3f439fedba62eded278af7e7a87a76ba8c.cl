//{"A":0,"B":1,"K":2,"end":4,"start":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test2(global float* A, global float* B, float K, int start, int end) {
  for (int i = start; i < end; ++i)
    A[hook(0, i)] *= B[hook(1, i)] + K;
}