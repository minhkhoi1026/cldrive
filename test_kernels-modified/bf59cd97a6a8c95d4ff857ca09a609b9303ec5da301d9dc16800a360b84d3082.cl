//{"BGRtoRGB":2,"rgb":1,"yuv":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void yuv422toRgb(const global unsigned char* yuv, global unsigned char* rgb, const unsigned int BGRtoRGB) {
  int gid = get_global_id(0);
  int i = gid * 4;
  int j = gid * 6;

  unsigned int channelSwitch = 0;
  if (BGRtoRGB == 1)
    channelSwitch = 2;

  int u = yuv[hook(0, i)];
  int y1 = yuv[hook(0, i + 1)];
  int v = yuv[hook(0, i + 2)];
  int y2 = yuv[hook(0, i + 3)];

  int c = y1 - 16;
  int d = u - 128;
  int e = v - 128;

  int r = (298 * c + 409 * e + 128) >> 8;
  int g = (298 * c + 100 * d - 208 * e + 128) >> 8;
  int b = (298 * c + 516 * d + 128) >> 8;
  if (r < 0)
    r = 0;
  if (r > 255)
    r = 255;
  if (g < 0)
    g = 0;
  if (g > 255)
    g = 255;
  if (b < 0)
    b = 0;
  if (b > 255)
    b = 255;

  rgb[hook(1, j + channelSwitch)] = (unsigned char)r;
  rgb[hook(1, j + 1)] = (unsigned char)g;
  rgb[hook(1, j + 2 - channelSwitch)] = (unsigned char)b;

  c = y2 - 16;
  r = (298 * c + 409 * e + 128) >> 8;
  g = (298 * c + 100 * d - 208 * e + 128) >> 8;
  b = (298 * c + 516 * d + 128) >> 8;
  if (r < 0)
    r = 0;
  if (r > 255)
    r = 255;
  if (g < 0)
    g = 0;
  if (g > 255)
    g = 255;
  if (b < 0)
    b = 0;
  if (b > 255)
    b = 255;

  rgb[hook(1, j + 3 + channelSwitch)] = (unsigned char)r;
  rgb[hook(1, j + 4)] = (unsigned char)g;
  rgb[hook(1, j + 5 - channelSwitch)] = (unsigned char)b;
}