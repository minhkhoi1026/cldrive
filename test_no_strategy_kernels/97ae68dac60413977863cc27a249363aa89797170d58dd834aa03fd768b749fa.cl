//{"E":0,"Ep":4,"N":5,"dx":2,"nx":1,"xp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void interp_CIC(global const double* E, int nx, double dx, global const double* xp, global double* Ep, int N) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);
  int left, right;
  double xis;

  while (gid < N) {
    xis = xp[hook(3, gid)] / dx;
    left = (int)(floor(xis));
    right = (left + 1) % nx;
    Ep[hook(4, gid)] = E[hook(0, left)] * (left + 1 - xis) + E[hook(0, right)] * (xis - left);
    gid += stride;
  }
}