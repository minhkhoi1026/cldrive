//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int x(private int n, private int b) {
  int t = 0;
  return ((n + b) + t);
}
kernel void brahmaKernel(global int* buf) {
  int p = 9;
  buf[hook(0, 0)] = x(7, 9);
}