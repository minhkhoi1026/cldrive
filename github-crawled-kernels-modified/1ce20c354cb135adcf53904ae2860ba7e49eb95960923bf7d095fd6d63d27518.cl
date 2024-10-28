//{"dst":0,"mask_const":2,"mask_global":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void null_kernel_arg(global unsigned int* dst, global unsigned int* mask_global, constant unsigned int* mask_const) {
  if (dst && mask_global == 0 && mask_const == ((void*)0)) {
    unsigned int idx = (unsigned int)get_global_id(0);
    dst[hook(0, idx)] = idx;
  }
}