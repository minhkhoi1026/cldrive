//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float luma(float4 sample) {
  return dot(sample.xyz, (float3)(0.299f, 0.587f, 0.114f));
}

kernel void fxaa(read_only image2d_t input, write_only image2d_t output) {
  const int2 size = get_image_dim(input);
  const float2 rcpSize = (float2)(1.0f / size.x, 1.0f / size.y);

  const int2 ipos = (int2)(get_global_id(0), get_global_id(1));
  const float2 pos = (float2)((ipos.x + 0.5f) * rcpSize.x, (ipos.y + 0.5f) * rcpSize.y);

  if (ipos.x >= size.x || ipos.y >= size.y)
    return;

  const sampler_t sampler = 1 | 2 | 0x20;

  float4 sampleM = read_imagef(input, sampler, (float2)(pos));
  float lumaM = luma(sampleM);
  float lumaS = luma(read_imagef(input, sampler, (float2)(pos + (float2)((0) * rcpSize.x, (1) * rcpSize.y))));
  float lumaE = luma(read_imagef(input, sampler, (float2)(pos + (float2)((1) * rcpSize.x, (0) * rcpSize.y))));
  float lumaN = luma(read_imagef(input, sampler, (float2)(pos + (float2)((0) * rcpSize.x, (-1) * rcpSize.y))));
  float lumaW = luma(read_imagef(input, sampler, (float2)(pos + (float2)((-1) * rcpSize.x, (0) * rcpSize.y))));

  float maxSM = max(lumaS, lumaM);
  float minSM = min(lumaS, lumaM);
  float maxESM = max(lumaE, maxSM);
  float minESM = min(lumaE, minSM);
  float maxWN = max(lumaN, lumaW);
  float minWN = min(lumaN, lumaW);
  float rangeMax = max(maxWN, maxESM);
  float rangeMin = min(minWN, minESM);
  float rangeMaxScaled = rangeMax * 0.1660f;
  float range = rangeMax - rangeMin;
  float rangeMaxClamped = max(0.0833f, rangeMaxScaled);

  if (range < rangeMaxClamped) {
    write_imagef(output, ipos, sampleM);
    return;
  }

  float lumaNW = luma(read_imagef(input, sampler, (float2)(pos + (float2)((-1) * rcpSize.x, (-1) * rcpSize.y))));
  float lumaSE = luma(read_imagef(input, sampler, (float2)(pos + (float2)((1) * rcpSize.x, (1) * rcpSize.y))));
  float lumaNE = luma(read_imagef(input, sampler, (float2)(pos + (float2)((1) * rcpSize.x, (-1) * rcpSize.y))));
  float lumaSW = luma(read_imagef(input, sampler, (float2)(pos + (float2)((-1) * rcpSize.x, (1) * rcpSize.y))));

  float lumaNS = lumaN + lumaS;
  float lumaWE = lumaW + lumaE;
  float subpixRcpRange = 1.0f / range;
  float subpixNSWE = lumaNS + lumaWE;
  float edgeHorz1 = (-2.0f * lumaM) + lumaNS;
  float edgeVert1 = (-2.0f * lumaM) + lumaWE;

  float lumaNESE = lumaNE + lumaSE;
  float lumaNWNE = lumaNW + lumaNE;
  float edgeHorz2 = (-2.0f * lumaE) + lumaNESE;
  float edgeVert2 = (-2.0f * lumaN) + lumaNWNE;

  float lumaNWSW = lumaNW + lumaSW;
  float lumaSWSE = lumaSW + lumaSE;
  float edgeHorz4 = (fabs(edgeHorz1) * 2.0f) + fabs(edgeHorz2);
  float edgeVert4 = (fabs(edgeVert1) * 2.0f) + fabs(edgeVert2);
  float edgeHorz3 = (-2.0f * lumaW) + lumaNWSW;
  float edgeVert3 = (-2.0f * lumaS) + lumaSWSE;
  float edgeHorz = fabs(edgeHorz3) + edgeHorz4;
  float edgeVert = fabs(edgeVert3) + edgeVert4;

  float subpixNWSWNESE = lumaNWSW + lumaNESE;
  float lengthSign = rcpSize.x;
  bool horzSpan = edgeHorz >= edgeVert;
  float subpixA = subpixNSWE * 2.0f + subpixNWSWNESE;

  if (!horzSpan)
    lumaN = lumaW;
  if (!horzSpan)
    lumaS = lumaE;
  if (horzSpan)
    lengthSign = rcpSize.y;
  float subpixB = (subpixA * (1.0f / 12.0f)) - lumaM;

  float gradientN = lumaN - lumaM;
  float gradientS = lumaS - lumaM;
  float lumaNN = lumaN + lumaM;
  float lumaSS = lumaS + lumaM;
  bool pairN = fabs(gradientN) >= fabs(gradientS);
  float gradient = max(fabs(gradientN), fabs(gradientS));
  if (pairN)
    lengthSign = -lengthSign;
  float subpixC = clamp(fabs(subpixB) * subpixRcpRange, 0.0f, 1.0f);

  float2 posB;
  posB.x = pos.x;
  posB.y = pos.y;
  float2 offNP;
  offNP.x = (!horzSpan) ? 0.0f : rcpSize.x;
  offNP.y = (horzSpan) ? 0.0f : rcpSize.y;
  if (!horzSpan)
    posB.x += lengthSign * 0.5f;
  if (horzSpan)
    posB.y += lengthSign * 0.5f;
  float2 posN;
  posN.x = posB.x - offNP.x * 1.0f;
  posN.y = posB.y - offNP.y * 1.0f;
  float2 posP;
  posP.x = posB.x + offNP.x * 1.0f;
  posP.y = posB.y + offNP.y * 1.0f;
  float subpixD = ((-2.0f) * subpixC) + 3.0f;
  float lumaEndN = luma(read_imagef(input, sampler, (float2)(posN)));
  float subpixE = subpixC * subpixC;
  float lumaEndP = luma(read_imagef(input, sampler, (float2)(posP)));

  if (!pairN)
    lumaNN = lumaSS;
  float gradientScaled = gradient * 1.0f / 4.0f;
  float lumaMM = lumaM - lumaNN * 0.5f;
  float subpixF = subpixD * subpixE;
  bool lumaMLTZero = lumaMM < 0.0f;

  lumaEndN -= lumaNN * 0.5f;
  lumaEndP -= lumaNN * 0.5f;
  bool doneN = fabs(lumaEndN) >= gradientScaled;
  bool doneP = fabs(lumaEndP) >= gradientScaled;
  if (!doneN)
    posN.x -= offNP.x * 1.5f;
  if (!doneN)
    posN.y -= offNP.y * 1.5f;
  bool doneNP = (!doneN) || (!doneP);
  if (!doneP)
    posP.x += offNP.x * 1.5f;
  if (!doneP)
    posP.y += offNP.y * 1.5f;

  if (doneNP) {
    if (!doneN)
      lumaEndN = luma(read_imagef(input, sampler, (float2)(posN.xy)));
    if (!doneP)
      lumaEndP = luma(read_imagef(input, sampler, (float2)(posP.xy)));
    if (!doneN)
      lumaEndN = lumaEndN - lumaNN * 0.5f;
    if (!doneP)
      lumaEndP = lumaEndP - lumaNN * 0.5f;
    doneN = fabs(lumaEndN) >= gradientScaled;
    doneP = fabs(lumaEndP) >= gradientScaled;
    if (!doneN)
      posN.x -= offNP.x * 2.0f;
    if (!doneN)
      posN.y -= offNP.y * 2.0f;
    doneNP = (!doneN) || (!doneP);
    if (!doneP)
      posP.x += offNP.x * 2.0f;
    if (!doneP)
      posP.y += offNP.y * 2.0f;

    if (doneNP) {
      if (!doneN)
        lumaEndN = luma(read_imagef(input, sampler, (float2)(posN.xy)));
      if (!doneP)
        lumaEndP = luma(read_imagef(input, sampler, (float2)(posP.xy)));
      if (!doneN)
        lumaEndN = lumaEndN - lumaNN * 0.5f;
      if (!doneP)
        lumaEndP = lumaEndP - lumaNN * 0.5f;
      doneN = fabs(lumaEndN) >= gradientScaled;
      doneP = fabs(lumaEndP) >= gradientScaled;
      if (!doneN)
        posN.x -= offNP.x * 4.0f;
      if (!doneN)
        posN.y -= offNP.y * 4.0f;
      doneNP = (!doneN) || (!doneP);
      if (!doneP)
        posP.x += offNP.x * 4.0f;
      if (!doneP)
        posP.y += offNP.y * 4.0f;

      if (doneNP) {
        if (!doneN)
          lumaEndN = luma(read_imagef(input, sampler, (float2)(posN.xy)));
        if (!doneP)
          lumaEndP = luma(read_imagef(input, sampler, (float2)(posP.xy)));
        if (!doneN)
          lumaEndN = lumaEndN - lumaNN * 0.5f;
        if (!doneP)
          lumaEndP = lumaEndP - lumaNN * 0.5f;
        doneN = fabs(lumaEndN) >= gradientScaled;
        doneP = fabs(lumaEndP) >= gradientScaled;
        if (!doneN)
          posN.x -= offNP.x * 12.0f;
        if (!doneN)
          posN.y -= offNP.y * 12.0f;
        doneNP = (!doneN) || (!doneP);
        if (!doneP)
          posP.x += offNP.x * 12.0f;
        if (!doneP)
          posP.y += offNP.y * 12.0f;
      }
    }
  }

  float dstN = pos.x - posN.x;
  float dstP = posP.x - pos.x;
  if (!horzSpan)
    dstN = pos.y - posN.y;
  if (!horzSpan)
    dstP = posP.y - pos.y;

  bool goodSpanN = (lumaEndN < 0.0f) != lumaMLTZero;
  float spanLength = (dstP + dstN);
  bool goodSpanP = (lumaEndP < 0.0f) != lumaMLTZero;
  float spanLengthRcp = 1.0f / spanLength;

  bool directionN = dstN < dstP;
  float dst = min(dstN, dstP);
  bool goodSpan = directionN ? goodSpanN : goodSpanP;
  float subpixG = subpixF * subpixF;
  float pixelOffset = (dst * (-spanLengthRcp)) + 0.5f;
  float subpixH = subpixG * 0.7500f;

  float pixelOffsetGood = goodSpan ? pixelOffset : 0.0f;
  float pixelOffsetSubpix = max(pixelOffsetGood, subpixH);

  float2 outPos = pos;
  if (!horzSpan)
    outPos.x += pixelOffsetSubpix * lengthSign;
  if (horzSpan)
    outPos.y += pixelOffsetSubpix * lengthSign;

  write_imagef(output, ipos, read_imagef(input, sampler, (float2)(outPos)));
}