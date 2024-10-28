//{"degree":8,"in":9,"inHeight":2,"inPixelPitch":4,"inRowPitch":6,"inWidth":0,"out":10,"outHeight":3,"outPixelPitch":5,"outRowPitch":7,"outWidth":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affineTrans(const int inWidth, const int outWidth, const int inHeight, const int outHeight, const int inPixelPitch, const int outPixelPitch, const int inRowPitch, const int outRowPitch, const float degree, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  float radian = radians(degree);

  int outY = y - (outHeight / 2);
  int outX = x - (outWidth / 2);

  float inY = (float)(outX * sin(radian) + outY * cos(radian));
  float inX = (float)(outX * cos(radian) - outY * sin(radian));

  int inFixX = (int)round(inX);
  int inFixY = (int)round(inY);

  inFixY += (inHeight / 2);
  inFixX += (inWidth / 2);

  int dst = (y * outRowPitch) + (x * outPixelPitch);

  if (inFixY >= 0 && inFixY < (inHeight - 1) && inFixX >= 0 && inFixX < (inWidth - 1)) {
    int src = (inFixY * inRowPitch) + (inFixX * inPixelPitch);

    for (int rgb = 0; rgb < 3; rgb++)
      out[hook(10, dst + rgb)] = in[hook(9, src + rgb)];
  }
}