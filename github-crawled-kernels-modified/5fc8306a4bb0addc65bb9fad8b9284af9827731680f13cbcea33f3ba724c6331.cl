//{"centerCx":3,"centerCy":4,"height":2,"maxIterations":7,"output":0,"width":1,"zoomX":5,"zoomY":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeMandelbrot(global unsigned int* output, int width, int height, double centerCx, double centerCy, double zoomX, double zoomY, int maxIterations) {
  unsigned int ix = get_global_id(0);
  unsigned int iy = get_global_id(1);

  double cx = centerCx - zoomX / 2.0f + ((double)ix / (width - 1)) * zoomX;
  double cy = centerCy - zoomY / 2.0f + ((double)iy / (height - 1)) * zoomY;

  double magnitudeSquared = 0;
  double x = 0;
  double y = 0;
  int iteration = 0;

  double xt;
  double yt;

  double xSquared;
  double ySquared;

  while (magnitudeSquared <= 16 && iteration < maxIterations) {
    xSquared = x * x;
    ySquared = y * y;

    xt = xSquared - ySquared + cx;
    yt = 2 * x * y + cy;
    x = xt;
    y = yt;

    magnitudeSquared = xSquared + ySquared;
    ++iteration;
  }

  output[hook(0, iy * width + ix)] = iteration;
}