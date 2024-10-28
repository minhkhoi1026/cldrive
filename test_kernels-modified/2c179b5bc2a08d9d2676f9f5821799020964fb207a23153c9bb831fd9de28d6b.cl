//{"a":1,"global_cols":4,"global_rows":3,"v":2,"y":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mxmulv_alt(global float* y, global const float* a, global const float* v, const unsigned int global_rows, const unsigned int global_cols) {
  for (unsigned int i = get_global_id(0); i < global_rows; i += (unsigned int)(get_global_size(0))) {
    float f = 0.f;
    for (unsigned int j = 0; j < global_cols; ++j)
      f += a[hook(1, i * global_cols + j)] * v[hook(2, j)];
    y[hook(0, i)] = f;
  }
}