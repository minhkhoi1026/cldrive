//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int g(private int x2, private int m) {
  return (m + x2);
}
int f(private int x, private int y) {
  int y0 = y;
  int y1 = y0;
  return g(x, y1);
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(1, 7);
}