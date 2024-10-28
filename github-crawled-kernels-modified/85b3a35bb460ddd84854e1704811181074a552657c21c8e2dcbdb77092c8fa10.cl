//{"degree":6,"in":7,"inHeight":2,"inPixelPitch":4,"inWidth":0,"out":8,"outHeight":3,"outPixelPitch":5,"outWidth":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affineTrans(const int inWidth, const int outWidth, const int inHeight, const int outHeight, const int inPixelPitch, const int outPixelPitch, const float degree, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int inRowPitch = inWidth * inPixelPitch;
  if (inRowPitch % 4)
    inRowPitch = inRowPitch + (4 - (inRowPitch % 4));

  int outRowPitch = outWidth * outPixelPitch;
  if (outRowPitch % 4)
    outRowPitch = outRowPitch + (4 - (outRowPitch % 4));

  float radian = radians(degree);

  int outY = y - (outHeight / 2);
  int outX = x - (outWidth / 2);

  float inY = (float)(outX * sin(radian) + outY * cos(radian));
  float inX = (float)(outX * cos(radian) - outY * sin(radian));

  int inFixX = (int)round(inX);
  int inFixY = (int)round(inY);

  float q = inY - (float)inFixY;
  float p = inX - (float)inFixX;

  inFixY += (inHeight / 2);
  inFixX += (inWidth / 2);

  int dst = (y * outRowPitch) + (x * outPixelPitch);

  if (inFixY >= 0 && inFixY < (inHeight - 1) && inFixX >= 0 && inFixX < (inWidth - 1)) {
    int srcX0 = inFixX * inPixelPitch;
    int srcX1 = srcX0 + inPixelPitch;
    int srcY0 = inFixY * inRowPitch;
    int srcY1 = srcY0 + inRowPitch;

    int src00 = srcY0 + srcX0;
    int src01 = srcY0 + srcX1;
    int src10 = srcY1 + srcX0;
    int src11 = srcY1 + srcX1;

    for (int rgb = 0; rgb < 3; rgb++)
      out[hook(8, dst + rgb)] = convert_uchar_sat((int)((1.0f - q) * ((1.0f - p) * (float)in[hook(7, src00 + rgb)] + p * (float)in[hook(7, src01 + rgb)]) + q * ((1.0f - p) * (float)in[hook(7, src10 + rgb)] + p * (float)in[hook(7, src11 + rgb)])));
  }
}