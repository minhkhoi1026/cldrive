//{"degree":3,"height":1,"in":4,"out":5,"pixelPitch":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affineTrans(const int width, const int height, const int pixelPitch, const float degree, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  float radian = radians(degree);

  int yc = height / 2;
  int xc = width / 2;
  int outY = y - yc;
  int outX = x - xc;

  float inY = (float)(outX * sin(radian) + outY * cos(radian));
  float inX = (float)(outX * cos(radian) - outY * sin(radian));

  int inFixX = (int)round(inX);
  int inFixY = (int)round(inY);

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  int dst = y * rowPitch + x * pixelPitch;

  if ((inFixY >= -yc) && (inFixY < yc) && (inFixX >= -xc) && (inFixX < xc)) {
    int src = (inFixY + yc) * rowPitch + (inFixX + xc) * pixelPitch;

    out[hook(5, dst + 0)] = in[hook(4, src + 0)];
    out[hook(5, dst + 1)] = in[hook(4, src + 1)];
    out[hook(5, dst + 2)] = in[hook(4, src + 2)];
  }
}