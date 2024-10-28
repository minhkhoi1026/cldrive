//{"delta":8,"in":10,"inHeight":2,"inPixelPitch":4,"inRowPitch":6,"inWidth":0,"offset":9,"out":11,"outHeight":3,"outPixelPitch":5,"outRowPitch":7,"outWidth":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affineTrans(const int inWidth, const int outWidth, const int inHeight, const int outHeight, const int inPixelPitch, const int outPixelPitch, const int inRowPitch, const int outRowPitch, const float delta, const int offset, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int outY = y - (outHeight / 2);
  int outX = x - (outWidth / 2);

  float distance = sqrt(pow((float)outY, 2) + pow((float)outX, 2));
  distance = inHeight < 0 ? distance : -distance;
  float radian = radians(distance * delta);

  float inY = (float)(outX * sin(radian) + outY * cos(radian));
  float inX = (float)(outX * cos(radian) - outY * sin(radian));

  int inFixX = (int)round(inX);
  int inFixY = (int)round(inY);

  float q = inY - (float)inFixY;
  float p = inX - (float)inFixX;

  inFixY += (abs(inHeight) / 2);
  inFixX += (inWidth / 2);

  int dst = (y * outRowPitch) + (x * outPixelPitch);

  if (inFixY >= 0 && inFixY < (abs(inHeight) - 1) && inFixX >= 0 && inFixX < (inWidth - 1)) {
    int srcX0 = inFixX * inPixelPitch;
    int srcX1 = srcX0 + inPixelPitch;
    int srcY0 = inFixY * inRowPitch;
    int srcY1 = srcY0 + inRowPitch;

    int src00 = srcY0 + srcX0;
    int src01 = srcY0 + srcX1;
    int src10 = srcY1 + srcX0;
    int src11 = srcY1 + srcX1;

    for (int rgb = 0; rgb < 3; rgb++)
      out[hook(11, dst + rgb)] = convert_uchar_sat((int)((1.0f - q) * ((1.0f - p) * (float)in[hook(10, src00 + rgb + offset)] + p * (float)in[hook(10, src01 + rgb + offset)]) + q * ((1.0f - p) * (float)in[hook(10, src10 + rgb + offset)] + p * (float)in[hook(10, src11 + rgb + offset)])));
  }
}