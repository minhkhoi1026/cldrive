//{"colorLUT":5,"framebuffer":4,"maxIterations":3,"stepSize":2,"windowWidth":6,"x0":0,"y0":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hw_mandelbrot_frame(const float x0, const float y0, const float stepSize, const unsigned int maxIterations, global unsigned int* restrict framebuffer, constant const unsigned int* restrict colorLUT, const unsigned int windowWidth) {
  const size_t windowPosX = get_global_id(0);
  const size_t windowPosY = get_global_id(1);
  const float stepPosX = x0 + (windowPosX * stepSize);
  const float stepPosY = y0 - (windowPosY * stepSize);

  float x = 0.0;
  float y = 0.0;
  float xSqr = 0.0;
  float ySqr = 0.0;
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