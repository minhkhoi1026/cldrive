//{"cols":2,"elements_per_row":4,"input":0,"output":1,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int bayerSampleOffset(int step, int rows, int x, int y) {
  return mad24(y, step, x) + ((y % 2) + (x % 2)) * rows * step;
}

kernel void runColorMultiplexingBayer(global const float* input, global float* output, const int cols, const int rows, const int elements_per_row) {
  int gidx = get_global_id(0) * 4, gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }

  int offset = mad24(gidy, elements_per_row, gidx);
  float4 val;
  val.x = input[hook(0, bayerSampleOffset(elements_per_row, rows, gidx + 0, gidy))];
  val.y = input[hook(0, bayerSampleOffset(elements_per_row, rows, gidx + 1, gidy))];
  val.z = input[hook(0, bayerSampleOffset(elements_per_row, rows, gidx + 2, gidy))];
  val.w = input[hook(0, bayerSampleOffset(elements_per_row, rows, gidx + 3, gidy))];
  vstore4(val, 0, output + offset);
}