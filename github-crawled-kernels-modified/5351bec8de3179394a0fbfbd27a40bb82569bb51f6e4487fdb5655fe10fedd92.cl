//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  int y = 3;
  int x = y;
  int f = x;
  buf[hook(0, 0)] = f;
}