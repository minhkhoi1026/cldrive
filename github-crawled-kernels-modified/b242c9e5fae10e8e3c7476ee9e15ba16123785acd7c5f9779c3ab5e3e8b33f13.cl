//{"a":0,"axis":4,"b":1,"cols":3,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_sum_i32(global int* a, global int* b, ulong rows, ulong cols, ulong axis) {
  ulong i = get_global_id(0);

  b[hook(1, i)] = 0.0;

  if (axis == 0) {
    for (ulong m = 0; m < rows; m++) {
      b[hook(1, i)] += a[hook(0, m * cols + i)];
    }
  } else if (axis == 1) {
    for (ulong m = 0; m < cols; m++) {
      b[hook(1, i)] += a[hook(0, i * cols + m)];
    }
  }
}