//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  for (int i = 1; (i <= 2); i++) {
    int i0 = 2;
    buf[hook(0, 1)] = i0;
  };
}