//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_kernel_3(global unsigned int* dst) {
  dst[hook(0, get_global_id(0))] = 0;
}