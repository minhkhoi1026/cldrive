//{"arg1":1,"dst":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_kernel_1(global const unsigned int* src, const unsigned int arg1, global unsigned int* dst) {
  unsigned int idx = get_global_id(0);

  dst[hook(2, idx)] = src[hook(0, idx)] + arg1;
}