//{"a":0,"b":1,"cols":3,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_transpose_f32(global const float* a, global float* b, const ulong rows, const ulong cols) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);
  b[hook(1, j * rows + i)] = a[hook(0, i * cols + j)];
}