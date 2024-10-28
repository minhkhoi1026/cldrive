//{"in":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_kernel_gpu(global int* in) {
  int i = get_global_id(0);
  in[hook(0, i)] = (int)i;
}