//{"centerCx":3,"centerCy":4,"height":2,"maxIterations":7,"output":0,"width":1,"zoomX":5,"zoomY":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeMandelbrot(global unsigned int* output, int width, int height, float centerCx, float centerCy, float zoomX, float zoomY, int maxIterations) {
  unsigned int ix = get_global_id(0);
  unsigned int iy = get_global_id(1);

  float cx = centerCx - zoomX / 2.0f + ((float)ix / (width - 1)) * zoomX;
  float cy = centerCy - zoomY / 2.0f + ((float)iy / (height - 1)) * zoomY;

  float magnitudeSquared = 0;
  float x = 0;
  float y = 0;
  int iteration = 0;

  float xt;
  float yt;

  float xSquared;
  float ySquared;

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