//{"m":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int g(global int* m, private int k) {
  return ((k + m[hook(0, 0)]) + m[hook(0, 1)]);
}
int z(private int a, global int* m, private int t) {
  return ((m[hook(0, 2)] + a) - t);
}
int y(global int* m, private int l, private int n, private int a) {
  int x0 = ((5 - n) + g(m, 4));
  return z(a, m, ((a + x0) + l));
}
int x(global int* m, private int n) {
  int l = m[hook(0, 9)];
  int r = y(m, l, n, 6);
  return (r + m[hook(0, 3)]);
}
kernel void brahmaKernel(global int* m) {
  int p = m[hook(0, 0)];
  m[hook(0, 0)] = x(m, 7);
}