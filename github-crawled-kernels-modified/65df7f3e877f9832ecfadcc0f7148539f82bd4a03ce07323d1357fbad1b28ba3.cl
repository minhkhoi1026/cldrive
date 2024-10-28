//{"E":3,"dx":2,"nx":1,"phi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_E(global const double* phi, int nx, double dx, global double* E) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);
  int left, right;

  const double scale = -1.0 / (2 * dx);

  while (gid < nx) {
    if (gid == 0)
      E[hook(3, 0)] = phi[hook(0, 1)] - phi[hook(0, nx - 1)];
    else if (gid == nx - 1)
      E[hook(3, nx - 1)] = phi[hook(0, 0)] - phi[hook(0, nx - 2)];
    else
      E[hook(3, gid)] = phi[hook(0, gid + 1)] - phi[hook(0, gid - 1)];

    E[hook(3, gid)] *= scale;

    gid += stride;
  }
}