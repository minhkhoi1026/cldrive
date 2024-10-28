//{"a":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void uninitialized_address(global ulong* output) {
  int a[] = {1, 2, 3};
  volatile int i, j;

  a[hook(1, i)] = 4;

  output[hook(0, 0)] = a[hook(1, j)];
}