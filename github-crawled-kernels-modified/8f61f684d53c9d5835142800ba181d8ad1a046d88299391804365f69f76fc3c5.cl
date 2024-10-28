//{"colorMap":7,"colorMapSize":8,"height":1,"maxIterations":9,"output":6,"rangeX":4,"rangeY":5,"width":0,"x0":2,"y0":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandelbrot(const int width, const int height, const float x0, const float y0, const float rangeX, const float rangeY, global unsigned int* output, global unsigned int* colorMap, const int colorMapSize, const int maxIterations) {
  unsigned int ix = get_global_id(0);
  unsigned int iy = get_global_id(1);

  float r = x0 + ix * rangeX / width;
  float i = y0 + iy * rangeY / height;

  float x = 0;
  float y = 0;

  float magnitudeSquared = 0;
  int iteration = 0;

  while (magnitudeSquared < 4 && iteration < maxIterations) {
    float x2 = x * x;
    float y2 = y * y;
    y = 2 * x * y + i;
    x = x2 - y2 + r;
    magnitudeSquared = x2 + y2;
    iteration++;
  }

  if (iteration == maxIterations) {
    output[hook(6, iy * width + ix)] = 0;

  } else {
    float alpha = (float)iteration / maxIterations;
    int colorIndex = (int)(alpha * colorMapSize);
    output[hook(6, iy * width + ix)] = colorMap[hook(7, colorIndex)];
  }
}