//{"N":5,"dx":2,"grid":0,"nx":1,"q":4,"xp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void weight_CIC(global double* grid, int nx, double dx, global const double* xp, global const double* q, int N) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);
  int left, right;
  double xis;

  while (gid < N) {
    xis = xp[hook(3, gid)] / dx;
    left = (int)(floor(xis));
    right = (left + 1) % nx;
    grid[hook(0, left)] += q[hook(4, gid)] * (left + 1 - xis);
    grid[hook(0, right)] += q[hook(4, gid)] * (xis - left);
    gid += stride;
  }
}