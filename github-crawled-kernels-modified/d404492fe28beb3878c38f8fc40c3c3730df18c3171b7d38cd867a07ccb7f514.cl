//{"((const __global float *)(alignedGMod + srcIndex))":3,"N":2,"alignedGMod":1,"angles":0}
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

kernel void non_maximum(global const float16* restrict angles, global const float16* restrict alignedGMod, global float16* restrict N) {
  unsigned int dstXStride = get_global_size(0);
  unsigned int dstIndex = 16 * get_global_id(1) * dstXStride + get_global_id(0);
  unsigned int srcXStride = dstXStride + 2;
  unsigned int srcIndex = 16 * get_global_id(1) * srcXStride + get_global_id(0) + 1;
  float a = *(((global const float*)(alignedGMod + srcIndex)) - 1);
  float16 b = vload16(0, ((global const float*)(alignedGMod + srcIndex)));
  float c = ((global const float*)(alignedGMod + srcIndex))[hook(3, 16)];
  srcIndex += srcXStride;
  float d = *(((global const float*)(alignedGMod + srcIndex)) - 1);
  float16 e = vload16(0, ((global const float*)(alignedGMod + srcIndex)));
  float f = ((global const float*)(alignedGMod + srcIndex))[hook(3, 16)];
  for (int k = 0; k < 16; ++k) {
    unsigned int dstPaddedIndex = srcIndex;
    float16 angle = vload16(0, (global const float*)(angles + dstIndex));
    angle = select(angle, angle - 3.14159265f, isgreater(angle, 3.14159265f));
    srcIndex += srcXStride;
    float g = *(((global const float*)(alignedGMod + srcIndex)) - 1);
    float16 h = vload16(0, ((global const float*)(alignedGMod + srcIndex)));
    float i = ((global const float*)(alignedGMod + srcIndex))[hook(3, 16)];

    int16 atest = islessequal(fabs(angle - 1.570796325f), 0.39269908125f);
    float16 p1 = select(0, ((float16)(d, e.s0123, e.s456789ab, e.scde)), atest);
    float16 p2 = select(0, ((float16)(e.s123, e.s4567, e.s89abcdef, f)), atest);
    atest = isless(fabs(angle - 0.7853981625f), 0.39269908125f);
    p1 = select(p1, ((float16)(b.s123, b.s4567, b.s89abcdef, c)), atest);
    p2 = select(p2, ((float16)(g, h.s0123, h.s456789ab, h.scde)), atest);
    atest = islessequal(angle, 0.39269908125f) || islessequal(fabs(angle - 3.14159265f), 0.39269908125f);
    p1 = select(p1, (b), atest);
    p2 = select(p2, (h), atest);
    atest = isless(fabs(angle - 3.f * 0.7853981625f), 0.39269908125f);
    p1 = select(p1, ((float16)(a, b.s0123, b.s456789ab, b.scde)), atest);
    p2 = select(p2, ((float16)(h.s123, h.s4567, h.s89abcdef, i)), atest);
    vstore16(select(0, (e), isless(p2, (e)) && isless(p1, (e))), 0, (global float*)(N + dstPaddedIndex));
    a = d;
    b = e;
    c = f;
    d = g;
    e = h;
    f = i;
    dstIndex += dstXStride;
  }
}