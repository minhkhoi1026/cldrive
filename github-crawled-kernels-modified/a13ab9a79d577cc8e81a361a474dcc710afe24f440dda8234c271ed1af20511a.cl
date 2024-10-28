//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  int f1 = 5;
  int f0 = f1;
  int f = f0;
  buf[hook(0, 0)] = f;
}