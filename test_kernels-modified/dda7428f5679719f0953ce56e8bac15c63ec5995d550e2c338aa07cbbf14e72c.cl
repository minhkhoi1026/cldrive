//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  int x = 2;
  buf[hook(0, 0)] = x;
  int y = 2;
  buf[hook(0, 1)] = y;
}