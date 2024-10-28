//{"A":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test7(global int* A) {
  for (int i = 1024; i > 0; --i)
    A[hook(0, i)] += 1;
}