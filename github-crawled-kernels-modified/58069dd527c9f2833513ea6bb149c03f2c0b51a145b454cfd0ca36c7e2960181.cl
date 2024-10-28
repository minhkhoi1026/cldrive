//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int g(private int q, private int w) {
  return ((1 + q) + w);
}
int t(private int p) {
  return (7 - p);
}
int f(private int m, private int k) {
  return (g(1, 2) - ((m * k) / t(53)));
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(1, 4);
}