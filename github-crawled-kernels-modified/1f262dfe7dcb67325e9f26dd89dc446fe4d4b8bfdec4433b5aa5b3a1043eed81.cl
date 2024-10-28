//{"cx":9,"cy":10,"fractal_data_array":0,"magn":8,"max_iterations":5,"size_x":6,"size_y":7,"x0":1,"x1":2,"y0":3,"y1":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int redChannelOffset = 0;
constant int greenChannelOffset = 1;
constant int blueChannelOffset = 2;
constant int channelsPerPixel = 4;
uchar calc_one_pixel(float x0, float y0, int max_iterations, int size_x, int size_y, float magn, float cx, float cy, int gpu) {
  int iter;
  float fx0, fy0, xtemp, x, y, mu;

  uchar float3;

  fx0 = x0 - size_x / 2.0f;
  fy0 = y0 - size_y / 2.0f;
  fx0 = fx0 / magn + cx;
  fy0 = fy0 / magn + cy;

  iter = 0;
  x = 0;
  y = 0;

  while (((x * x + y * y) <= 32) && (iter < max_iterations)) {
    xtemp = x * x - y * y + fx0;
    y = 2 * x * y + fy0;
    x = xtemp;
    iter++;
  }

  if (iter == max_iterations) {
    return 0;
  }

  iter = 0;
  x = 0;
  y = 0;
  mu = 0;

  while (((x * x + y * y) <= 32) && (iter < max_iterations)) {
    xtemp = x * x - y * y + fx0;
    y = 2 * x * y + fy0;
    x = xtemp;
    mu += exp(-sqrt(x * x + y * y));
    iter++;
  }

  const unsigned int b = convert_uint_sat(256 * mu);
  const unsigned int g = (b / 8);
  const unsigned int r = (g / 16);

  const uchar gray = convert_uchar_sat(0.21f * r + 0.72f * g + 0.07f * b);
  return gray;
}

kernel void mono_mandelbrot(global uchar* fractal_data_array, unsigned int x0, unsigned int x1, unsigned int y0, unsigned int y1, unsigned int max_iterations, unsigned int size_x, unsigned int size_y, float magn, float cx, float cy) {
  const int x = get_global_id(0) + x0;
  const int y = get_global_id(1) + y0;

  const int pixelIndex = channelsPerPixel * (x1 - x0) * (y - y0) + channelsPerPixel * (x - x0);
  const int pixelRedChannelIndex = pixelIndex + redChannelOffset;
  const int pixelGreenChannelIndex = pixelIndex + greenChannelOffset;
  const int pixelBlueChannelIndex = pixelIndex + blueChannelOffset;

  fractal_data_array[hook(0, pixelRedChannelIndex)] = fractal_data_array[hook(0, pixelGreenChannelIndex)] = fractal_data_array[hook(0, pixelBlueChannelIndex)] = calc_one_pixel(x, y, max_iterations, size_x, size_y, magn, cx, cy, 255);
  fractal_data_array[hook(0, pixelIndex + 3)] = 255;
}