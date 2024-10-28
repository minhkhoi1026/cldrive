//{"height":2,"max":3,"offset_x":5,"offset_y":6,"out":0,"width":1,"zoom":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float calc_iteration(float xpx, float ypx, float max, float width, float height) {
  float x0 = ((xpx / width) * (float)3.5) - (float)2.5;
  float y0 = ((ypx / height) * (float)2) - (float)1;

  float x = 0;
  float y = 0;

  float iteration = 0;

  while ((x * x) + (y * y) < (2 * 2) && iteration < max) {
    float xtemp = (x * x) - (y * y) + x0;
    y = (2 * x * y) + y0;
    x = xtemp;
    iteration += 1;
  }
  return iteration;
}

kernel void mandelbrot(global float* out, int width, int height, float max, float zoom, float offset_x, float offset_y) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int out_offset = (y * width) + x;

  float fx = (((float)x) + offset_x) / zoom;
  float fy = (((float)y) + offset_y) / zoom;

  out[hook(0, out_offset)] = calc_iteration(fx, fy, max, (float)width, (float)height) / max;
}