//{"_a":8,"_tau":7,"cols":2,"elements_per_row":4,"in_offset":5,"input":0,"out_offset":6,"output":1,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void horizontalCausalFilter_addInput(global const float* input, global float* output, const int cols, const int rows, const int elements_per_row, const int in_offset, const int out_offset, const float _tau, const float _a) {
  int gid = get_global_id(0);
  if (gid >= rows) {
    return;
  }

  global const float* iptr = input + mad24(gid, elements_per_row, in_offset / 4);
  global float* optr = output + mad24(gid, elements_per_row, out_offset / 4);

  float res;
  float4 in_v4, out_v4, sum_v4, res_v4 = (float4)(0);

  for (int i = 0; i < cols / 4; ++i, iptr += 4, optr += 4) {
    in_v4 = vload4(0, iptr);
    out_v4 = vload4(0, optr) * _tau;
    sum_v4 = in_v4 + out_v4;

    res_v4.x = sum_v4.x + _a * res_v4.w;
    res_v4.y = sum_v4.y + _a * res_v4.x;
    res_v4.z = sum_v4.z + _a * res_v4.y;
    res_v4.w = sum_v4.w + _a * res_v4.z;

    vstore4(res_v4, 0, optr);
  }

  optr = output + mad24(gid + 1, elements_per_row, -4 + out_offset / 4);
  res_v4 = (float4)(0);
  for (int i = 0; i < elements_per_row / 4; ++i, optr -= 4) {
    out_v4 = vload4(0, optr);

    res_v4.w = out_v4.w + _a * res_v4.x;
    res_v4.z = out_v4.z + _a * res_v4.w;
    res_v4.y = out_v4.y + _a * res_v4.z;
    res_v4.x = out_v4.x + _a * res_v4.y;

    vstore4(res_v4, 0, optr);
  }
}