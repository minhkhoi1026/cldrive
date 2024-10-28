//{"X0cube":6,"cols":2,"elements_per_row":4,"input":0,"maxVal":5,"output":1,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int bayerSampleOffset(int step, int rows, int x, int y) {
  return mad24(y, step, x) + ((y % 2) + (x % 2)) * rows * step;
}

kernel void normalizeGrayOutputNearZeroCentreredSigmoide(global float* input, global float* output, const int cols, const int rows, const int elements_per_row, const float maxVal, const float X0cube) {
  const int gidx = get_global_id(0) * 4, gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }
  const int offset = mad24(gidy, elements_per_row, gidx);
  float4 currentCubeLuminance = vload4(0, input + offset);
  currentCubeLuminance = currentCubeLuminance * currentCubeLuminance * currentCubeLuminance;
  float4 val = currentCubeLuminance * X0cube / (X0cube + currentCubeLuminance);
  vstore4(val, 0, output + offset);
}