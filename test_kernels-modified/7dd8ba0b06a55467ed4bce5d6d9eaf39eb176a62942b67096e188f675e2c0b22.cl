//{"buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brahmaKernel(global int* buf) {
  int id = get_local_id(0);
  buf[hook(0, id)] = 0;
}