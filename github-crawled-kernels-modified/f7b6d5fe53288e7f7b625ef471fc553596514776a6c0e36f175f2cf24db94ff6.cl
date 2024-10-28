//{"colorLUT":5,"framebuffer":4,"maxIterations":3,"stepSize":2,"windowWidth":6,"x0":0,"y0":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hw_mandelbrot_frame(const double x0, const double y0, const double stepSize, const unsigned int maxIterations, global unsigned int* restrict framebuffer, constant const unsigned int* restrict colorLUT, const unsigned int windowWidth) {
  const size_t windowPosX = get_global_id(0);
  const size_t windowPosY = get_global_id(1);

  const double stepPosX = x0 + (windowPosX * stepSize);
  const double stepPosY = y0 - (windowPosY * stepSize);

  double x = 0.0;
  double y = 0.0;
  double xSqr = 0.0;
  double ySqr = 0.0;
  unsigned int iterations = 0;

  while (xSqr + ySqr < 4.0 && iterations < maxIterations) {
    xSqr = x * x;
    ySqr = y * y;

    y = 2 * x * y + stepPosY;
    x = xSqr - ySqr + stepPosX;

    iterations++;
  }

  framebuffer[hook(4, windowWidth * windowPosY + windowPosX)] = (iterations == maxIterations) ? 0x00000000 : colorLUT[hook(5, iterations)];
}