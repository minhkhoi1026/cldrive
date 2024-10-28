//{"cols":1,"elements_per_row":3,"indices":8,"input":0,"pB":6,"pG":5,"pR":4,"rows":2,"vals":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int bayerSampleOffset(int step, int rows, int x, int y) {
  return mad24(y, step, x) + ((y % 2) + (x % 2)) * rows * step;
}

kernel void substractResidual(global float* input, const int cols, const int rows, const int elements_per_row, const float pR, const float pG, const float pB) {
  const int gidx = get_global_id(0) * 4, gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }
  int indices[3] = {mad24(gidy, elements_per_row, gidx), mad24(gidy + rows, elements_per_row, gidx), mad24(gidy + 2 * rows, elements_per_row, gidx)};
  float4 vals[3];
  vals[hook(7, 0)] = vload4(0, input + indices[hook(8, 0)]);
  vals[hook(7, 1)] = vload4(0, input + indices[hook(8, 1)]);
  vals[hook(7, 2)] = vload4(0, input + indices[hook(8, 2)]);

  float4 residu = pR * vals[hook(7, 0)] + pG * vals[hook(7, 1)] + pB * vals[hook(7, 2)];
  vstore4(vals[hook(7, 0)] - residu, 0, input + indices[hook(8, 0)]);
  vstore4(vals[hook(7, 1)] - residu, 0, input + indices[hook(8, 1)]);
  vstore4(vals[hook(7, 2)] - residu, 0, input + indices[hook(8, 2)]);
}