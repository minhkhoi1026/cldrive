//{"((const __global uchar *)(input + srcIndex))":11,"BSx":7,"BSy":8,"alignedGMod":10,"alpha_s":3,"fore_th":4,"grad_dir":6,"input":5,"is_first_run":2,"is_minus1":0,"is_plus2":1,"mapRes":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar16 myselectuc16(uchar16 afalse, uchar16 atrue, int16 condition) {
  uchar16 one = 1;
  uchar16 cond = convert_uchar16(condition * condition);
  uchar16 not_cond = one - cond;
  return atrue * cond + afalse * not_cond;
}
int16 myselecti16(int16 afalse, int16 atrue, int16 condition) {
  int16 cond = condition * condition;
  int16 not_cond = 1 - cond;
  return atrue * cond + afalse * not_cond;
}

kernel void SobelAndMagicDetector(const int is_minus1, const int is_plus2, const int is_first_run, const float alpha_s, const float fore_th, global const uchar16* restrict input, global float16* restrict grad_dir, global float16* restrict BSx, global float16* restrict BSy, global uchar16* restrict mapRes, global float16* restrict alignedGMod) {
  unsigned int dstXStride = get_global_size(0);
  unsigned int dstIndex = 16 * get_global_id(1) * dstXStride + get_global_id(0);
  unsigned int srcXStride = dstXStride + 2;
  unsigned int srcIndex = 16 * get_global_id(1) * srcXStride + get_global_id(0) + 1;
  const float16 as = alpha_s;
  const float16 fth = fore_th;
  const float16 v19 = 19;
  float a = *(((global const uchar*)(input + srcIndex)) - 1);
  float16 b = convert_float16(vload16(0, ((global const uchar*)(input + srcIndex))));
  float c = ((global const uchar*)(input + srcIndex))[hook(11, 16)];
  srcIndex += srcXStride;
  float d = *(((global const uchar*)(input + srcIndex)) - 1);
  float16 e = convert_float16(vload16(0, ((global const uchar*)(input + srcIndex))));
  float f = ((global const uchar*)(input + srcIndex))[hook(11, 16)];
  int16 fr = is_first_run;
  for (int k = 0; k < 16; ++k) {
    unsigned int dstAlignedIndex = srcIndex;
    srcIndex += srcXStride;
    float g = *(((global const uchar*)(input + srcIndex)) - 1);
    float16 h = convert_float16(vload16(0, ((global const uchar*)(input + srcIndex))));
    float i = ((global const uchar*)(input + srcIndex))[hook(11, 16)];
    float16 Gx = (((float16)(g, h.s0123, h.s456789ab, h.scde)) + 2 * (h) + ((float16)(h.s123, h.s4567, h.s89abcdef, i))) - (((float16)(a, b.s0123, b.s456789ab, b.scde)) + 2 * (b) + ((float16)(b.s123, b.s4567, b.s89abcdef, c)));
    float16 Gy = (((float16)(b.s123, b.s4567, b.s89abcdef, c)) + 2 * ((float16)(e.s123, e.s4567, e.s89abcdef, f)) + ((float16)(h.s123, h.s4567, h.s89abcdef, i))) - (((float16)(a, b.s0123, b.s456789ab, b.scde)) + 2 * ((float16)(d, e.s0123, e.s456789ab, e.scde)) + ((float16)(g, h.s0123, h.s456789ab, h.scde)));
    float16 an = atan2(Gy, Gx);

    float16 mag = fabs(Gx) + fabs(Gy);
    vstore16(mag, 0, (global float*)(alignedGMod + dstAlignedIndex));

    an = select(an, an + 6.2831853f, isless(an, 0));
    vstore16(an, 0, (global float*)(grad_dir + dstIndex));
    float16 bx = select(vload16(0, (global float*)(BSx + dstIndex)), Gx, fr);
    float16 by = select(vload16(0, (global float*)(BSy + dstIndex)), Gy, fr);
    float16 D_Sx = Gx - bx;
    bx += D_Sx * as;
    vstore16(bx, 0, (global float*)(BSx + dstIndex));
    float16 D_Sy = Gy - by;
    by += D_Sy * as;
    vstore16(by, 0, (global float*)(BSy + dstIndex));
    if (is_minus1 || is_plus2) {
      const int16 zeros = 0;
      const int16 ones = 1;
      const int16 twos = 2;
      const int16 twos5 = 255;
      int16 mr = convert_int16(vload16(0, (global uchar*)(mapRes + dstIndex)));
      mr -= is_minus1;
      int16 c1 = isgreater(fabs(D_Sx), fth) && isgreater(fabs(Gx), v19);
      int16 c2 = isgreater(fabs(D_Sy), fth) && isgreater(fabs(Gy), v19);
      mr += select(zeros, ones, c2 || c1) * twos;
      c1 = mr < zeros;
      c2 = select(mr, zeros, c1);
      c1 = c2 > twos5;
      mr = is_plus2 * select(c2, twos5, c1);
      vstore16(convert_uchar16(mr), 0, (global uchar*)(mapRes + dstIndex));
    }
    a = d;
    b = e;
    c = f;
    d = g;
    e = h;
    f = i;
    dstIndex += dstXStride;
  }
}