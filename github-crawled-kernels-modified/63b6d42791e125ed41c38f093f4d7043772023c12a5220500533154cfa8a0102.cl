//{"Np":2,"Nx_loc":6,"dxm1_loc":5,"ff_loc":4,"w":1,"x":0,"xx_loc":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void profile_by_interpolant(global double* x, global double* w, unsigned int Np, global double* xx_loc, global double* ff_loc, global double* dxm1_loc, unsigned int Nx_loc) {
  unsigned int ip = (unsigned int)get_global_id(0);
  if (ip < Np) {
    double xp = x[hook(0, ip)];
    unsigned int ix;

    for (ix = 0; ix < Nx_loc - 1; ix++) {
      if (xp > xx_loc[hook(3, ix)] && xp <= xx_loc[hook(3, ix + 1)]) {
        break;
      }
    }

    double f_minus = ff_loc[hook(4, ix)] * dxm1_loc[hook(5, ix)];
    double f_plus = ff_loc[hook(4, ix + 1)] * dxm1_loc[hook(5, ix)];

    w[hook(1, ip)] *= f_minus * (xx_loc[hook(3, ix + 1)] - x[hook(0, ip)]) + f_plus * (x[hook(0, ip)] - xx_loc[hook(3, ix)]);
  }
}