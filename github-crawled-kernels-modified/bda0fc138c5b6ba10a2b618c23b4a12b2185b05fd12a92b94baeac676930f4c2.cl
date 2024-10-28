//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int g(private int m) {
  return (m + 1);
}
int f(private int y) {
  int y0 = y;
  int y1 = y0;
  return g(y1);
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(7);
}