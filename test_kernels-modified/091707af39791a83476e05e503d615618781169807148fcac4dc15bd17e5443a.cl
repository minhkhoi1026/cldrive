//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  int x = 0;
  int y = (x + 1);
  int z = (y * 2);
  int a = (z - x);
  int i = (a / 2);
  buf[hook(0, 0)] = i;
}