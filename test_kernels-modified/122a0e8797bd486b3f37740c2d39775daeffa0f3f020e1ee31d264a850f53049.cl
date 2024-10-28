//{"_a":5,"_gain":6,"cols":1,"elements_per_row":3,"input":8,"optr":7,"out_offset":4,"output":0,"result":9,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void verticalCausalFilter_multichannel(global float* output, const int cols, const int rows, const int elements_per_row, const int out_offset, const float _a, const float _gain) {
  int gid = get_global_id(0) * 2;
  if (gid >= cols) {
    return;
  }

  global float* optr[3];
  float2 input[3];
  float2 result[3] = {(float2)0, (float2)0, (float2)0};

  optr[hook(7, 0)] = output + gid + out_offset / 4;
  optr[hook(7, 1)] = output + gid + out_offset / 4 + rows * elements_per_row;
  optr[hook(7, 2)] = output + gid + out_offset / 4 + 2 * rows * elements_per_row;

  for (int i = 0; i < rows; ++i) {
    input[hook(8, 0)] = vload2(0, optr[hook(7, 0)]);
    input[hook(8, 1)] = vload2(0, optr[hook(7, 1)]);
    input[hook(8, 2)] = vload2(0, optr[hook(7, 2)]);

    result[hook(9, 0)] = input[hook(8, 0)] + _a * result[hook(9, 0)];
    result[hook(9, 1)] = input[hook(8, 1)] + _a * result[hook(9, 1)];
    result[hook(9, 2)] = input[hook(8, 2)] + _a * result[hook(9, 2)];

    vstore2(result[hook(9, 0)], 0, optr[hook(7, 0)]);
    vstore2(result[hook(9, 1)], 0, optr[hook(7, 1)]);
    vstore2(result[hook(9, 2)], 0, optr[hook(7, 2)]);

    optr[hook(7, 0)] += elements_per_row;
    optr[hook(7, 1)] += elements_per_row;
    optr[hook(7, 2)] += elements_per_row;
  }

  optr[hook(7, 0)] = output + (rows - 1) * elements_per_row + gid + out_offset / 4;
  optr[hook(7, 1)] = output + (rows - 1) * elements_per_row + gid + out_offset / 4 + rows * elements_per_row;
  optr[hook(7, 2)] = output + (rows - 1) * elements_per_row + gid + out_offset / 4 + 2 * rows * elements_per_row;
  result[hook(9, 0)] = result[hook(9, 1)] = result[hook(9, 2)] = (float2)0;

  for (int i = 0; i < rows; ++i) {
    input[hook(8, 0)] = vload2(0, optr[hook(7, 0)]);
    input[hook(8, 1)] = vload2(0, optr[hook(7, 1)]);
    input[hook(8, 2)] = vload2(0, optr[hook(7, 2)]);

    result[hook(9, 0)] = input[hook(8, 0)] + _a * result[hook(9, 0)];
    result[hook(9, 1)] = input[hook(8, 1)] + _a * result[hook(9, 1)];
    result[hook(9, 2)] = input[hook(8, 2)] + _a * result[hook(9, 2)];

    vstore2(_gain * result[hook(9, 0)], 0, optr[hook(7, 0)]);
    vstore2(_gain * result[hook(9, 1)], 0, optr[hook(7, 1)]);
    vstore2(_gain * result[hook(9, 2)], 0, optr[hook(7, 2)]);

    optr[hook(7, 0)] -= elements_per_row;
    optr[hook(7, 1)] -= elements_per_row;
    optr[hook(7, 2)] -= elements_per_row;
  }
}