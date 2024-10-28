//{"arg0":0,"dst":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_kernel_2(const unsigned int arg0, global unsigned int* dst) {
  unsigned int idx = get_global_id(0);

  dst[hook(1, idx)] = arg0;
}