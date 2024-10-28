//{"rasterParams":4,"resultLine":3,"scanLine1":0,"scanLine2":1,"scanLine3":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void processNineCellWindow(global float* scanLine1, global float* scanLine2, global float* scanLine3, global uchar4* resultLine, global float* rasterParams) {
  const int i = get_global_id(0);

  float x11 = scanLine1[hook(0, i)];
  float x12 = scanLine1[hook(0, i + 1)];
  float x13 = scanLine1[hook(0, i + 2)];
  float x21 = scanLine2[hook(1, i)];
  float x22 = scanLine2[hook(1, i + 1)];
  float x23 = scanLine2[hook(1, i + 2)];
  float x31 = scanLine3[hook(2, i)];
  float x32 = scanLine3[hook(2, i + 1)];
  float x33 = scanLine3[hook(2, i + 2)];

  if (x22 == rasterParams[hook(4, 0)]) {
    float alpha = rasterParams[hook(4, 8)] * rasterParams[hook(4, 16)];
    resultLine[hook(3, i)] = (uchar4)(rasterParams[hook(4, 13)] * alpha, rasterParams[hook(4, 14)] * alpha, rasterParams[hook(4, 15)] * alpha, 255 * alpha);
  } else {
    if (x11 == rasterParams[hook(4, 0)])
      x11 = x22;
    if (x12 == rasterParams[hook(4, 0)])
      x12 = x22;
    if (x13 == rasterParams[hook(4, 0)])
      x13 = x22;
    if (x21 == rasterParams[hook(4, 0)])
      x21 = x22;

    if (x23 == rasterParams[hook(4, 0)])
      x23 = x22;
    if (x31 == rasterParams[hook(4, 0)])
      x31 = x22;
    if (x32 == rasterParams[hook(4, 0)])
      x32 = x22;
    if (x33 == rasterParams[hook(4, 0)])
      x33 = x22;

    float derX = ((x13 + x23 + x23 + x33) - (x11 + x21 + x21 + x31)) / (8.0f * rasterParams[hook(4, 3)]);
    float derY = ((x31 + x32 + x32 + x33) - (x11 + x12 + x12 + x13)) / (8.0f * -rasterParams[hook(4, 4)]);

    if (derX == rasterParams[hook(4, 0)] || derX == rasterParams[hook(4, 0)]) {
      float alpha = rasterParams[hook(4, 5)] * rasterParams[hook(4, 16)];
      resultLine[hook(3, i)] = (uchar4)(rasterParams[hook(4, 13)] * alpha, rasterParams[hook(4, 14)] * alpha, rasterParams[hook(4, 15)] * alpha, 255 * alpha);
    } else {
      float res;
      if (rasterParams[hook(4, 17)]) {
        const float xx = derX * derX;
        const float yy = derY * derY;
        const float xx_plus_yy = xx + yy;

        if (xx_plus_yy == 0.0f) {
          res = clamp(1.0f + rasterParams[hook(4, 9)], 0.0f, 255.0f);
        } else {
          float val225_mul_127 = rasterParams[hook(4, 10)] + (derX - derY) * rasterParams[hook(4, 11)];
          val225_mul_127 = (val225_mul_127 <= 0.0f) ? 0.0f : val225_mul_127;
          float val270_mul_127 = rasterParams[hook(4, 10)] - derX * rasterParams[hook(4, 12)];
          val270_mul_127 = (val270_mul_127 <= 0.0f) ? 0.0f : val270_mul_127;
          float val315_mul_127 = rasterParams[hook(4, 10)] + (derX + derY) * rasterParams[hook(4, 11)];
          val315_mul_127 = (val315_mul_127 <= 0.0f) ? 0.0f : val315_mul_127;
          float val360_mul_127 = rasterParams[hook(4, 10)] - derY * rasterParams[hook(4, 12)];
          val360_mul_127 = (val360_mul_127 <= 0.0f) ? 0.0f : val360_mul_127;

          const float weight_225 = 0.5f * xx_plus_yy - derX * derY;
          const float weight_270 = xx;
          const float weight_315 = xx_plus_yy - weight_225;
          const float weight_360 = yy;
          const float cang_mul_127 = ((weight_225 * val225_mul_127 + weight_270 * val270_mul_127 + weight_315 * val315_mul_127 + weight_360 * val360_mul_127) / xx_plus_yy) / (1.0f + rasterParams[hook(4, 8)] * xx_plus_yy);
          res = clamp(1.0f + cang_mul_127, 0.0f, 255.0f);
        }
      } else {
        res = (rasterParams[hook(4, 9)] - (derY * rasterParams[hook(4, 6)] - derX * rasterParams[hook(4, 7)])) / sqrt(1.0f + rasterParams[hook(4, 8)] * (derX * derX + derY * derY));
        res = res <= 0.0f ? 1.0f : 1.0f + res;
      }
      res = res * rasterParams[hook(4, 5)];
      resultLine[hook(3, i)] = (uchar4)(res, res, res, 255 * rasterParams[hook(4, 5)]);
    }
  }
}