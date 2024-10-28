//{"cols":3,"elements_per_row":5,"grad_offset":7,"gradient":1,"in_offset":6,"input":0,"out_offset":8,"output":2,"rows":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adaptiveHorizontalCausalFilter_addInput(global const float* input, global const float* gradient, global float* output, const int cols, const int rows, const int elements_per_row, const int in_offset, const int grad_offset, const int out_offset) {
  int gid = get_global_id(0);
  if (gid >= rows) {
    return;
  }

  global const float* iptr = input + mad24(gid, elements_per_row, in_offset / 4);
  global const float* gptr = gradient + mad24(gid, elements_per_row, grad_offset / 4);
  global float* optr = output + mad24(gid, elements_per_row, out_offset / 4);

  float4 in_v4, grad_v4, out_v4, res_v4 = (float4)(0);
  for (int i = 0; i < cols / 4; ++i, iptr += 4, gptr += 4, optr += 4) {
    in_v4 = vload4(0, iptr);
    grad_v4 = vload4(0, gptr);

    res_v4.x = in_v4.x + grad_v4.x * res_v4.w;
    res_v4.y = in_v4.y + grad_v4.y * res_v4.x;
    res_v4.z = in_v4.z + grad_v4.z * res_v4.y;
    res_v4.w = in_v4.w + grad_v4.w * res_v4.z;

    vstore4(res_v4, 0, optr);
  }

  optr = output + mad24(gid + 1, elements_per_row, -4 + out_offset / 4);
  gptr = gradient + mad24(gid + 1, elements_per_row, -4 + grad_offset / 4);
  res_v4 = (float4)(0);

  for (int i = 0; i < cols / 4; ++i, gptr -= 4, optr -= 4) {
    grad_v4 = vload4(0, gptr);
    out_v4 = vload4(0, optr);

    res_v4.w = out_v4.w + grad_v4.w * res_v4.x;
    res_v4.z = out_v4.z + grad_v4.z * res_v4.w;
    res_v4.y = out_v4.y + grad_v4.y * res_v4.z;
    res_v4.x = out_v4.x + grad_v4.x * res_v4.y;

    vstore4(res_v4, 0, optr);
  }
}