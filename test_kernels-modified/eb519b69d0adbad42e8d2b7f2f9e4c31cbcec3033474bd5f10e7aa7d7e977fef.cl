//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void even_squares_kernel_gpu(global const int* in, global int* out) {
  int i = get_global_id(0) * 2;
  out[hook(1, i)] = in[hook(0, i)] * in[hook(0, i)];
}