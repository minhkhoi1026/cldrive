//{"color_tab":3,"p_height":2,"p_screenBuffer":0,"p_width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void colorize(global unsigned int* p_screenBuffer, int p_width, int p_height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= p_width)
    return;
  if (y >= p_height)
    return;

  if (x >= p_width * 3 / 4) {
    return;
  }

  int of = x + y * p_width;
  int a = p_screenBuffer[hook(0, of)];

  float3 color_tab[4] = {{0.8, 1.0, 0.3}, {1.0, 0.7, 0.3}, {1.5, 0.8, 0.1}, {0.2, 0.8, 0.2}};

  int col = a & 3;
  float3 rgb = color_tab[hook(3, col)];
  float i = convert_float((a & (255 - 7)));
  int r = i * rgb.x;
  if (r > 255)
    r = 255;
  int g = i * rgb.y;
  if (g > 255)
    g = 255;
  int b = i * rgb.z;
  if (b > 255)
    b = 255;
  p_screenBuffer[hook(0, of)] = b + g * 256 + r * 65536;

  if ((a & 0xffff00) == 0xffff00)
    p_screenBuffer[hook(0, of)] = 0x0088cc;
}