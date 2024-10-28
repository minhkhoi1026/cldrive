//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void func_kernel(global float* a, global float* b, global float* c) {
  unsigned int i = get_global_id(0);

  int j = 1;
  int iej = i != j;
  c[hook(2, i)] = 0.1 * iej;
}