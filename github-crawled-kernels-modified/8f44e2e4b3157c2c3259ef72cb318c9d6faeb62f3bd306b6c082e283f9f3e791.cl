//{"fInputImage":0,"fOutputImage":1,"fScale":5,"iRadius":4,"uiHeight":3,"uiWidth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BoxCols_32F(global float* fInputImage, global float* fOutputImage, unsigned int uiWidth, unsigned int uiHeight, int iRadius, float fScale) {
  size_t globalPosX = get_global_id(0);
  size_t globalPosD = get_global_id(2);
  size_t offset = mul24(mul24(globalPosD, uiHeight), uiWidth) + globalPosX;
  fInputImage = &fInputImage[hook(0, offset)];
  fOutputImage = &fOutputImage[hook(1, offset)];

  float fSum;
  fSum = fInputImage[hook(0, 0)] * (float)(iRadius);
  for (int y = 0; y < iRadius + 1; y++) {
    fSum += fInputImage[hook(0, y * uiWidth)];
  }
  fOutputImage[hook(1, 0)] = fSum * fScale;
  for (int y = 1; y < iRadius + 1; y++) {
    fSum += fInputImage[hook(0, (y + iRadius) * uiWidth)];
    fSum -= fInputImage[hook(0, 0)];
    fOutputImage[hook(1, y * uiWidth)] = fSum * fScale;
  }

  for (int y = iRadius + 1; y < uiHeight - iRadius; y++) {
    fSum += fInputImage[hook(0, (y + iRadius) * uiWidth)];
    fSum -= fInputImage[hook(0, ((y - iRadius) * uiWidth) - uiWidth)];
    fOutputImage[hook(1, y * uiWidth)] = fSum * fScale;
  }

  for (int y = uiHeight - iRadius; y < uiHeight; y++) {
    fSum += fInputImage[hook(0, (uiHeight - 1) * uiWidth)];
    fSum -= fInputImage[hook(0, ((y - iRadius) * uiWidth) - uiWidth)];
    fOutputImage[hook(1, y * uiWidth)] = fSum * fScale;
  }
}