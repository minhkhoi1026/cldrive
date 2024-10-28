//{"height":1,"in":4,"out":5,"pixelPitch":2,"scale":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affineTrans(const int width, const int height, const int pixelPitch, const float scale, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int yc = height / 2;
  int xc = width / 2;
  int outY = y - yc;
  int outX = x - xc;

  float inY = outY / scale;
  float inX = outX / scale;

  int inFixY = (int)round(outY / scale);
  int inFixX = (int)round(outX / scale);

  float q = inY - (float)inFixY;
  float p = inX - (float)inFixX;

  inFixX += xc;
  inFixY += yc;

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  int dst = y * rowPitch + x * pixelPitch;

  if (inFixY >= 0 && inFixY < (height - 1) && inFixX >= 0 && inFixX < (width - 1)) {
    int srcX0 = inFixX * pixelPitch;
    int srcX1 = srcX0 + pixelPitch;
    int srcY0 = inFixY * rowPitch;
    int srcY1 = srcY0 + rowPitch;

    int src00 = srcY0 + srcX0;
    int src01 = srcY0 + srcX1;
    int src10 = srcY1 + srcX0;
    int src11 = srcY1 + srcX1;

    for (int rgb = 0; rgb < 3; rgb++)
      out[hook(5, dst + rgb)] = convert_uchar_sat(

          (int)((1.0f - q) * ((1.0f - p) * (float)in[hook(4, src00 + rgb)] + p * (float)in[hook(4, src01 + rgb)]) + q * ((1.0f - p) * (float)in[hook(4, src10 + rgb)] + p * (float)in[hook(4, src11 + rgb)]))

      );
  }
}