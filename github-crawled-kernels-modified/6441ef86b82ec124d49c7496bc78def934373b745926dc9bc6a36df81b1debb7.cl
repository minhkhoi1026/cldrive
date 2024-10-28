//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int x(private int y, private int z) {
  return (y + z);
}
int f(private int a, private int b) {
  return x(a, b);
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(1, 7);
}