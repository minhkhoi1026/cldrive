//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int f(private int x, private int y) {
  int x0 = x;
  return (x0 + y);
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(7, 8);
}