//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  for (int i = 0; (i <= 3); i++) {
    int x = (i * i);
    buf[hook(0, 0)] = x;
  };
}