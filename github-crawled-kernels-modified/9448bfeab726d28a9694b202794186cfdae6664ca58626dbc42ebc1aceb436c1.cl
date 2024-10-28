//{"_a":5,"_gain":6,"cols":1,"elements_per_row":3,"out_offset":4,"output":0,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void verticalCausalFilter(global float* output, const int cols, const int rows, const int elements_per_row, const int out_offset, const float _a, const float _gain) {
  int gid = get_global_id(0) * 2;
  if (gid >= cols) {
    return;
  }

  global float* optr = output + gid + out_offset / 4;
  float2 input;
  float2 result = (float2)0;
  for (int i = 0; i < rows; ++i, optr += elements_per_row) {
    input = vload2(0, optr);
    result = input + _a * result;
    vstore2(result, 0, optr);
  }

  optr = output + (rows - 1) * elements_per_row + gid + out_offset / 4;
  result = (float2)0;
  for (int i = 0; i < rows; ++i, optr -= elements_per_row) {
    input = vload2(0, optr);
    result = input + _a * result;
    vstore2(_gain * result, 0, optr);
  }
}