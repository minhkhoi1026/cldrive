//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void odd_squares_kernel_gpu(global int* out) {
  int i = (get_global_id(0) * 2) + 1;
  out[hook(0, i)] = out[hook(0, i - 1)] + (2 * i) - 1;
}