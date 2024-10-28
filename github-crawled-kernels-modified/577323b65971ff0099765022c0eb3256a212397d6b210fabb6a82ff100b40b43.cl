//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  int i = 1;
  for (int i0 = 0; (i0 <= (i + 1)); i0++) {
    int i1 = (i0 + 2);
    buf[hook(0, i1)] = 2;
  };
}