//{"cols":1,"elements_per_row":3,"input":0,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int bayerSampleOffset(int step, int rows, int x, int y) {
  return mad24(y, step, x) + ((y % 2) + (x % 2)) * rows * step;
}

kernel void inverseValue(global float* input, const int cols, const int rows, const int elements_per_row) {
  const int gidx = get_global_id(0) * 4, gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }
  const int offset = mad24(gidy, elements_per_row, gidx);
  float4 val = vload4(0, input + offset);
  val = 1.f / val;
  vstore4(val, 0, input + offset);
}