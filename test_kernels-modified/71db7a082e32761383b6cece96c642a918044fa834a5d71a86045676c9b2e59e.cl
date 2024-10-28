//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int g2(private int y1, private int r, private int t) {
  return ((r + y1) - t);
}
int n(private int y1, private int o) {
  return (o - g2(y1, y1, 2));
}
int g(private int y1, private int m) {
  return n(y1, 5);
}
int f(private int y) {
  int y0 = y;
  int y1 = y0;
  return g(y1, y1);
}
int z(private int y3) {
  return (y3 - 2);
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(z(7));
}