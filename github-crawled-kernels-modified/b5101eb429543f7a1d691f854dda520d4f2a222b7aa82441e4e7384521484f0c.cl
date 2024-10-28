//{"pDst":1,"pSrc":0,"uiRGBA":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void median_filter(const global unsigned int* pSrc, global unsigned int* pDst) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int width = get_global_size(0);
  const int height = get_global_size(1);

  const int iOffset = y * width;
  const int iPrev = iOffset - width;
  const int iNext = iOffset + width;
  unsigned int uiRGBA[9];

  if (((iPrev + x - 1) >= 0) && ((iNext + x + 1) < (height * width))) {
    uiRGBA[hook(2, 0)] = pSrc[hook(0, iPrev + x - 1)];
    uiRGBA[hook(2, 1)] = pSrc[hook(0, iPrev + x)];
    uiRGBA[hook(2, 2)] = pSrc[hook(0, iPrev + x + 1)];

    uiRGBA[hook(2, 3)] = pSrc[hook(0, iOffset + x - 1)];
    uiRGBA[hook(2, 4)] = pSrc[hook(0, iOffset + x)];
    uiRGBA[hook(2, 5)] = pSrc[hook(0, iOffset + x + 1)];

    uiRGBA[hook(2, 6)] = pSrc[hook(0, iNext + x - 1)];
    uiRGBA[hook(2, 7)] = pSrc[hook(0, iNext + x)];
    uiRGBA[hook(2, 8)] = pSrc[hook(0, iNext + x + 1)];

    unsigned int uiResult = 0;
    unsigned int uiMask = 0xFF;

    for (int ch = 0; ch < 4; ch++) {
      unsigned int r0, r1, r2, r3, r4, r5, r6, r7, r8;
      r0 = uiRGBA[hook(2, 0)] & uiMask;
      r1 = uiRGBA[hook(2, 1)] & uiMask;
      r2 = uiRGBA[hook(2, 2)] & uiMask;
      r3 = uiRGBA[hook(2, 3)] & uiMask;
      r4 = uiRGBA[hook(2, 4)] & uiMask;
      r5 = uiRGBA[hook(2, 5)] & uiMask;
      r6 = uiRGBA[hook(2, 6)] & uiMask;
      r7 = uiRGBA[hook(2, 7)] & uiMask;
      r8 = uiRGBA[hook(2, 8)] & uiMask;

      unsigned int uiMin = min(r0, r1);
      unsigned int uiMax = max(r0, r1);
      r0 = uiMin;
      r1 = uiMax;

      uiMin = min(r3, r2);
      uiMax = max(r3, r2);
      r3 = uiMin;
      r2 = uiMax;

      uiMin = min(r2, r0);
      uiMax = max(r2, r0);
      r2 = uiMin;
      r0 = uiMax;

      uiMin = min(r3, r1);
      uiMax = max(r3, r1);
      r3 = uiMin;
      r1 = uiMax;

      uiMin = min(r1, r0);
      uiMax = max(r1, r0);
      r1 = uiMin;
      r0 = uiMax;

      uiMin = min(r3, r2);
      uiMax = max(r3, r2);
      r3 = uiMin;
      r2 = uiMax;

      uiMin = min(r5, r4);
      uiMax = max(r5, r4);
      r5 = uiMin;
      r4 = uiMax;

      uiMin = min(r7, r8);
      uiMax = max(r7, r8);
      r7 = uiMin;
      r8 = uiMax;

      uiMin = min(r6, r8);
      uiMax = max(r6, r8);
      r6 = uiMin;
      r8 = uiMax;

      uiMin = min(r6, r7);
      uiMax = max(r6, r7);
      r6 = uiMin;
      r7 = uiMax;

      uiMin = min(r4, r8);
      uiMax = max(r4, r8);
      r4 = uiMin;
      r8 = uiMax;

      uiMin = min(r4, r6);
      uiMax = max(r4, r6);
      r4 = uiMin;
      r6 = uiMax;

      uiMin = min(r5, r7);
      uiMax = max(r5, r7);
      r5 = uiMin;
      r7 = uiMax;

      uiMin = min(r4, r5);
      uiMax = max(r4, r5);
      r4 = uiMin;
      r5 = uiMax;

      uiMin = min(r6, r7);
      uiMax = max(r6, r7);
      r6 = uiMin;
      r7 = uiMax;

      uiMin = min(r0, r8);
      uiMax = max(r0, r8);
      r0 = uiMin;
      r8 = uiMax;

      r4 = max(r0, r4);
      r5 = max(r1, r5);

      r6 = max(r2, r6);
      r7 = max(r3, r7);

      r4 = min(r4, r6);
      r5 = min(r5, r7);

      uiResult |= r4;

      uiMask <<= 8;
    }

    pDst[hook(1, iOffset + x)] = uiResult;
  } else {
    pDst[hook(1, iOffset + x)] = pSrc[hook(0, iOffset + x)];
  }
}