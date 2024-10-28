//{"elec":6,"epsi":0,"natom":8,"q":2,"sig":1,"vdw":7,"x":3,"y":4,"z":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void NonBonded_full(global const double* epsi, global const double* sig, global const double* q, global double* x, global double* y, global double* z, global double* elec, global double* vdw, const unsigned int natom) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  if (j > i) {
    double dx = x[hook(3, j)] - x[hook(3, i)];
    double dy = y[hook(4, j)] - y[hook(4, i)];
    double dz = z[hook(5, j)] - z[hook(5, i)];

    double r2 = dx * dx + dy * dy + dz * dz;
    double r6 = r2 * r2 * r2;
    double r12 = r6 * r6;
    double rt = 1.0 / sqrt(r2);

    double e = epsi[hook(0, i)] * epsi[hook(0, j)];
    double s = sig[hook(1, i)] + sig[hook(1, j)];

    elec[hook(6, i)] += q[hook(2, i)] * q[hook(2, j)] * rt;
    vdw[hook(7, i)] += e * ((s / r12) - (s / r6));
  }
}