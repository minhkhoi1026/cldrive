//{"buf":0,"colors":8,"colors[c1_idx]":9,"colors[c2_idx]":7,"ctr_x":2,"ctr_y":3,"dim":1,"max_iterations":5,"p":6,"range":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned char colors[16][3] = {
    {25, 7, 26}, {9, 1, 47}, {4, 4, 73}, {0, 7, 100}, {12, 44, 138}, {24, 82, 177}, {57, 125, 209}, {134, 181, 229}, {211, 236, 248}, {241, 233, 191}, {248, 201, 95}, {255, 170, 0}, {204, 128, 0}, {153, 87, 0}, {106, 52, 3}, {66, 30, 15},
};

void get_color(global unsigned char* p, double mu, int max_it) {
  if (mu >= max_it) {
    p[hook(6, 0)] = 0;
    p[hook(6, 1)] = 0;
    p[hook(6, 2)] = 0;
    return;
  }

  mu /= 6;

  int c1_idx = (int)mu % 16;
  int c2_idx = (c1_idx + 1) % 16;
  double offset = mu - (double)(int)mu;

  p[hook(6, 0)] = offset * (colors[hook(8, c2_idx)][hook(7, 0)] - colors[hook(8, c1_idx)][hook(9, 0)]) + colors[hook(8, c1_idx)][hook(9, 0)];
  p[hook(6, 1)] = offset * (colors[hook(8, c2_idx)][hook(7, 1)] - colors[hook(8, c1_idx)][hook(9, 1)]) + colors[hook(8, c1_idx)][hook(9, 1)];
  p[hook(6, 2)] = offset * (colors[hook(8, c2_idx)][hook(7, 2)] - colors[hook(8, c1_idx)][hook(9, 2)]) + colors[hook(8, c1_idx)][hook(9, 2)];
}

kernel void mandelbrot(global unsigned char* buf, int dim, double ctr_x, double ctr_y, double range, int max_iterations) {
  int col = get_global_id(0);
  int row = get_global_id(1);
  double x = ((double)col / (double)dim * range) + (ctr_x - range / 2);
  double y = ((double)row / (double)dim * range) + (ctr_y - range / 2);
  double x0 = x;
  double y0 = y;
  int iteration = 0;

  while (x * x + y * y < (2 * 2) && iteration < max_iterations) {
    double xtemp = x * x - y * y + x0;
    y = 2 * x * y + y0;
    x = xtemp;
    iteration++;
  }

  double mu = iteration;
  if (iteration < max_iterations)
    mu = iteration + 1 - log(log(sqrt(x * x + y * y))) / 0x1.62e42fefa39efp-1;

  get_color(&buf[hook(0, (row * dim + col) * 3)], mu, max_iterations);
}