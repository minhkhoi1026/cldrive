//{"dst":1,"height":3,"src":0,"stride":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float coeff51[] = {0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f};

kernel void iirblur_lr2(global const uchar* src, global uchar* dst, const unsigned int width, const unsigned int height, const unsigned int stride) {
  global const uchar* ptr = src + get_global_id(0) * 4 + get_global_id(1) * stride;
  global uchar* ptrDst = dst + get_global_id(0) * 4 + get_global_id(1) * stride;
  float4 tmps = convert_float4(vload4(0, ptr));
  float4 tmp1 = tmps, tmp2 = tmps, tmp3 = tmps;
  for (int i = 0; i < (24 + 64) / 4; i += 2) {
    float16 in1 = convert_float16(vload16(i, ptr));
    float16 in2 = convert_float16(vload16(i + 1, ptr));
    float16 out1;
    out1.s0123 = in1.s0123 * 0.345f + tmp1 * 0.37f + tmp2 * 0.679f + tmp3 * 0.038f;
    out1.s4567 = in1.s4567 * 0.345f + out1.s0123 * 0.37f + tmp1 * 0.679f + tmp2 * 0.038f;
    out1.s89ab = in1.s89ab * 0.345f + out1.s4567 * 0.37f + out1.s0123 * 0.679f + tmp1 * 0.038f;
    out1.scdef = in1.scdef * 0.345f + out1.s89ab * 0.37f + out1.s4567 * 0.679f + out1.s0123 * 0.038f;
    if (i >= 24 / 4)
      vstore16(convert_uchar16_sat(out1), i - 24 / 4, ptrDst);

    in1.s0123 = in2.s0123 * 0.345f + out1.scdef * 0.37f + out1.s89ab * 0.679f + out1.s4567 * 0.038f;
    in1.s4567 = in2.s4567 * 0.345f + in1.s0123 * 0.37f + out1.scdef * 0.679f + out1.s89ab * 0.038f;
    in1.s89ab = in2.s89ab * 0.345f + in1.s4567 * 0.37f + in1.s0123 * 0.679f + out1.s4567 * 0.038f;
    in1.scdef = in2.scdef * 0.345f + in1.s89ab * 0.37f + in1.s4567 * 0.679f + in1.s0123 * 0.038f;
    if (i >= 24 / 4)
      vstore16(convert_uchar16_sat(in1), i - 24 / 4 + 1, ptrDst);
    tmp3 = in1.s4567;
    tmp2 = in1.s89ab;
    tmp1 = in1.scdef;
  }
}