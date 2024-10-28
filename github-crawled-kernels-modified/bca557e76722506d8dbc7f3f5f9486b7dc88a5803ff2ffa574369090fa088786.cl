//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int x(private int y0) {
  return (6 - y0);
}
int f(private int y) {
  return x(y);
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = f(7);
}