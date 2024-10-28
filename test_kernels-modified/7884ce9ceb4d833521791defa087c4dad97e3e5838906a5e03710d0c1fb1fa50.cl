//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int x(private int n) {
  int r = 8;
  int h = (r + n);
  return h;
}
kernel void brahmaKernel(global int* buf) {
  buf[hook(0, 0)] = x(9);
}