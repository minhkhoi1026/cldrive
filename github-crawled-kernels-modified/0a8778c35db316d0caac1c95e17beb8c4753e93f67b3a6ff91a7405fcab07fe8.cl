//{"((const __global float *)(paddedN + srcIndex))":2,"paddedN":0,"result":1}
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

;

kernel void hysterisis(global const float16* restrict paddedN, global uchar16* restrict result) {
  const float16 T1 = 40.f;
  const float16 float2 = 3.f * T1;
  unsigned int dstXStride = get_global_size(0);
  unsigned int dstIndex = 16 * get_global_id(1) * dstXStride + get_global_id(0);
  unsigned int srcXStride = dstXStride + 2;
  unsigned int srcIndex = 16 * get_global_id(1) * srcXStride + get_global_id(0) + 1;
  float a = *(((global const float*)(paddedN + srcIndex)) - 1);
  float16 b = vload16(0, ((global const float*)(paddedN + srcIndex)));
  float c = ((global const float*)(paddedN + srcIndex))[hook(2, 16)];
  srcIndex += srcXStride;
  float d = *(((global const float*)(paddedN + srcIndex)) - 1);
  float16 e = vload16(0, ((global const float*)(paddedN + srcIndex)));
  float f = ((global const float*)(paddedN + srcIndex))[hook(2, 16)];
  int changes = 0;

  for (int k = 0; k < 16; ++k) {
    unsigned int dstPaddedIndex = srcIndex;
    srcIndex += srcXStride;
    float g = *(((global const float*)(paddedN + srcIndex)) - 1);
    float16 h = vload16(0, ((global const float*)(paddedN + srcIndex)));
    float i = ((global const float*)(paddedN + srcIndex))[hook(2, 16)];

    int16 surrounding_greater = isgreater((e), float2);
    surrounding_greater = surrounding_greater || isgreater(((float16)(a, b.s0123, b.s456789ab, b.scde)), float2);
    surrounding_greater = surrounding_greater || isgreater((b), float2);
    surrounding_greater = surrounding_greater || isgreater(((float16)(b.s123, b.s4567, b.s89abcdef, c)), float2);
    surrounding_greater = surrounding_greater || isgreater(((float16)(d, e.s0123, e.s456789ab, e.scde)), float2);
    surrounding_greater = surrounding_greater || isgreater(((float16)(e.s123, e.s4567, e.s89abcdef, f)), float2);
    surrounding_greater = surrounding_greater || isgreater(((float16)(g, h.s0123, h.s456789ab, h.scde)), float2);
    surrounding_greater = surrounding_greater || isgreater((h), float2);
    surrounding_greater = surrounding_greater || isgreater(((float16)(h.s123, h.s4567, h.s89abcdef, i)), float2);
    int16 PE = isgreater((e), T1);
    float16 nz5 = select(select(0, (e), PE), float2 + 1, surrounding_greater && PE);
    uchar16 hys = myselectuc16(0, 255, isgreater(nz5, float2));
    vstore16(hys, 0, (global uchar*)(result + dstIndex));
    a = d;
    b = e;
    c = f;
    d = g;
    e = h;
    f = i;
    dstIndex += dstXStride;
  }
}