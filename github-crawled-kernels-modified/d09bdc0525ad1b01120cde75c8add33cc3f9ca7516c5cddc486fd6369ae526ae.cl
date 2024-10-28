//{"a":0,"axis":4,"b":1,"c":2,"cols":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_divide_f32(global const float* a, global const float* b, global float* c, const ulong cols, const int axis) {
  ulong i = get_global_id(0);
  ulong j = get_global_id(1);
  if (axis == -1) {
    c[hook(2, i * cols + j)] = a[hook(0, i * cols + j)] / b[hook(1, i * cols + j)];
  } else if (axis == 0) {
    c[hook(2, i * cols + j)] = a[hook(0, i * cols + j)] / b[hook(1, j)];
  } else if (axis == 1) {
    c[hook(2, i * cols + j)] = a[hook(0, i * cols + j)] / b[hook(1, i)];
  }
}