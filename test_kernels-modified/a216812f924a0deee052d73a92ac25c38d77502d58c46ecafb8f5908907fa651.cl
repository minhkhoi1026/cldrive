//{"fScale":5,"iRadius":4,"uiHeight":3,"uiInputImage":0,"uiOutputImage":1,"uiWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 rgbaUintToFloat4(unsigned int c) {
  float4 rgba;
  rgba.x = c & 0xff;
  rgba.y = (c >> 8) & 0xff;
  rgba.z = (c >> 16) & 0xff;
  rgba.w = (c >> 24) & 0xff;
  return rgba;
}

unsigned int rgbaFloat4ToUint(float4 rgba, float fScale) {
  unsigned int uiPackedPix = 0U;
  uiPackedPix |= 0x000000FF & (unsigned int)(rgba.x * fScale);
  uiPackedPix |= 0x0000FF00 & (((unsigned int)(rgba.y * fScale)) << 8);
  uiPackedPix |= 0x00FF0000 & (((unsigned int)(rgba.z * fScale)) << 16);
  uiPackedPix |= 0xFF000000 & (((unsigned int)(rgba.w * fScale)) << 24);
  return uiPackedPix;
}
kernel void BoxColumns(global unsigned int* uiInputImage, global unsigned int* uiOutputImage, unsigned int uiWidth, unsigned int uiHeight, int iRadius, float fScale) {
  size_t globalPosX = get_global_id(0);
  uiInputImage = &uiInputImage[hook(0, globalPosX)];
  uiOutputImage = &uiOutputImage[hook(1, globalPosX)];

  float4 f4Sum;
  f4Sum = rgbaUintToFloat4(uiInputImage[hook(0, 0)]) * (float4)(iRadius);
  for (int y = 0; y < iRadius + 1; y++) {
    f4Sum += rgbaUintToFloat4(uiInputImage[hook(0, y * uiWidth)]);
  }
  uiOutputImage[hook(1, 0)] = rgbaFloat4ToUint(f4Sum, fScale);
  for (int y = 1; y < iRadius + 1; y++) {
    f4Sum += rgbaUintToFloat4(uiInputImage[hook(0, (y + iRadius) * uiWidth)]);
    f4Sum -= rgbaUintToFloat4(uiInputImage[hook(0, 0)]);
    uiOutputImage[hook(1, y * uiWidth)] = rgbaFloat4ToUint(f4Sum, fScale);
  }

  for (int y = iRadius + 1; y < uiHeight - iRadius; y++) {
    f4Sum += rgbaUintToFloat4(uiInputImage[hook(0, (y + iRadius) * uiWidth)]);
    f4Sum -= rgbaUintToFloat4(uiInputImage[hook(0, ((y - iRadius) * uiWidth) - uiWidth)]);
    uiOutputImage[hook(1, y * uiWidth)] = rgbaFloat4ToUint(f4Sum, fScale);
  }

  for (int y = uiHeight - iRadius; y < uiHeight; y++) {
    f4Sum += rgbaUintToFloat4(uiInputImage[hook(0, (uiHeight - 1) * uiWidth)]);
    f4Sum -= rgbaUintToFloat4(uiInputImage[hook(0, ((y - iRadius) * uiWidth) - uiWidth)]);
    uiOutputImage[hook(1, y * uiWidth)] = rgbaFloat4ToUint(f4Sum, fScale);
  }
}