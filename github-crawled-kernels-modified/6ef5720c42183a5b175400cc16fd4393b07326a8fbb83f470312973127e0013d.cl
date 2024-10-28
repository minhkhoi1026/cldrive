//{"X0":6,"cols":2,"elements_per_row":4,"input":0,"meanval":5,"output":1,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int bayerSampleOffset(int step, int rows, int x, int y) {
  return mad24(y, step, x) + ((y % 2) + (x % 2)) * rows * step;
}

kernel void normalizeGrayOutputCentredSigmoide(global const float* input, global float* output, const int cols, const int rows, const int elements_per_row, const float meanval, const float X0)

{
  int gidx = get_global_id(0) * 4, gidy = get_global_id(1);
  if (gidx >= cols || gidy >= rows) {
    return;
  }
  int offset = mad24(gidy, elements_per_row, gidx);

  float4 input_val = vload4(0, input + offset);
  input_val = meanval + (meanval + X0) * (input_val - meanval) / (fabs(input_val - meanval) + X0);
  vstore4(input_val, 0, output + offset);
}