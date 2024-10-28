//{"pDst":1,"pSrc":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter(global uchar* pSrc, global uchar* pDst) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int iOffset = y * (unsigned int)16;
  const int iPrev = iOffset - (unsigned int)16;
  const int iNext = iOffset + (unsigned int)16;

  uchar r0, r1, r2, r3, r4, r5, r6, r7, r8;
  r0 = pSrc[hook(0, iPrev + x - 1)];
  r1 = pSrc[hook(0, iPrev + x)];
  r2 = pSrc[hook(0, iPrev + x + 1)];

  r3 = pSrc[hook(0, iOffset + x - 1)];
  r4 = pSrc[hook(0, iOffset + x)];
  r5 = pSrc[hook(0, iOffset + x + 1)];

  r6 = pSrc[hook(0, iNext + x - 1)];
  r7 = pSrc[hook(0, iNext + x)];
  r8 = pSrc[hook(0, iNext + x + 1)];

  uchar uiResult = 0;

  uchar uiMin = min(r0, r1);
  uchar uiMax = max(r0, r1);
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

  pDst[hook(1, iOffset + x)] = (uchar)min(r4, r5);
}