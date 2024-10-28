//{"cols":4,"h":0,"out":2,"rows":3,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_dmse_f32(global float* h, global float* y, global float* out, const ulong rows, const ulong cols) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);

  unsigned int index = i * cols + j;
  out[hook(2, index)] = h[hook(0, index)] - y[hook(1, index)];
}