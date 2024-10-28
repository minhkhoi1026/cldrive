//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  while ((buf[hook(0, 0)] < 5)) {
    int x = (buf[hook(0, 0)] + 1);
    buf[hook(0, 0)] = (x * x);
  };
}