//{"buffer":1,"buffer_offset":6,"cols":2,"elements_per_row":4,"gain":7,"input":9,"optr":8,"out_offset":5,"output":0,"result":10,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void verticalCausalFilter_Irregular(global float* output, global float* buffer, const int cols, const int rows, const int elements_per_row, const int out_offset, const int buffer_offset, const float gain) {
  int gid = get_global_id(0) * 2;
  if (gid >= cols) {
    return;
  }

  global float* optr[3];
  global float* bptr = buffer + gid + buffer_offset / 4;
  float2 result[3] = {(float2)0, (float2)0, (float2)0};
  float2 grad, input[3];
  optr[hook(8, 0)] = output + gid + out_offset / 4;
  optr[hook(8, 1)] = output + gid + out_offset / 4 + rows * elements_per_row;
  optr[hook(8, 2)] = output + gid + out_offset / 4 + 2 * rows * elements_per_row;
  for (int i = 0; i < rows; ++i, bptr += elements_per_row) {
    input[hook(9, 0)] = vload2(0, optr[hook(8, 0)]);
    input[hook(9, 1)] = vload2(0, optr[hook(8, 1)]);
    input[hook(9, 2)] = vload2(0, optr[hook(8, 2)]);
    grad = vload2(0, bptr);
    result[hook(10, 0)] = input[hook(9, 0)] + grad * result[hook(10, 0)];
    result[hook(10, 1)] = input[hook(9, 1)] + grad * result[hook(10, 1)];
    result[hook(10, 2)] = input[hook(9, 2)] + grad * result[hook(10, 2)];
    vstore2(result[hook(10, 0)], 0, optr[hook(8, 0)]);
    vstore2(result[hook(10, 1)], 0, optr[hook(8, 1)]);
    vstore2(result[hook(10, 2)], 0, optr[hook(8, 2)]);
    optr[hook(8, 0)] += elements_per_row;
    optr[hook(8, 1)] += elements_per_row;
    optr[hook(8, 2)] += elements_per_row;
  }

  int start_idx = mad24(rows - 1, elements_per_row, gid);
  optr[hook(8, 0)] = output + start_idx + out_offset / 4;
  optr[hook(8, 1)] = output + start_idx + out_offset / 4 + rows * elements_per_row;
  optr[hook(8, 2)] = output + start_idx + out_offset / 4 + 2 * rows * elements_per_row;
  bptr = buffer + start_idx + buffer_offset / 4;
  result[hook(10, 0)] = result[hook(10, 1)] = result[hook(10, 2)] = (float2)0;
  for (int i = 0; i < rows; ++i, bptr -= elements_per_row) {
    input[hook(9, 0)] = vload2(0, optr[hook(8, 0)]);
    input[hook(9, 1)] = vload2(0, optr[hook(8, 1)]);
    input[hook(9, 2)] = vload2(0, optr[hook(8, 2)]);
    grad = vload2(0, bptr);
    result[hook(10, 0)] = input[hook(9, 0)] + grad * result[hook(10, 0)];
    result[hook(10, 1)] = input[hook(9, 1)] + grad * result[hook(10, 1)];
    result[hook(10, 2)] = input[hook(9, 2)] + grad * result[hook(10, 2)];
    vstore2(gain * result[hook(10, 0)], 0, optr[hook(8, 0)]);
    vstore2(gain * result[hook(10, 1)], 0, optr[hook(8, 1)]);
    vstore2(gain * result[hook(10, 2)], 0, optr[hook(8, 2)]);
    optr[hook(8, 0)] -= elements_per_row;
    optr[hook(8, 1)] -= elements_per_row;
    optr[hook(8, 2)] -= elements_per_row;
  }
}