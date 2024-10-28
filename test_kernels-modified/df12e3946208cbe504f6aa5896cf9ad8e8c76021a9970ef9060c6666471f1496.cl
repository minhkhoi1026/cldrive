//{"A":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test5(global float* A) {
  for (int i = 0; i < 1024; ++i)
    A[hook(0, i)] = i;
}