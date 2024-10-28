//{"Nppc_r":10,"Nppc_th":11,"Nppc_x":9,"Nx":7,"ncells":8,"rgrid":6,"theta_var":4,"w":3,"x":0,"xgrid":5,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_grid(global double* x, global double* y, global double* z, global double* w, global double* theta_var, global double* xgrid, global double* rgrid, unsigned int Nx, unsigned int ncells, unsigned int Nppc_x, unsigned int Nppc_r, unsigned int Nppc_th) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < ncells) {
    unsigned int Nx_cell = Nx - 1;
    unsigned int Nppc_loc = Nppc_x * Nppc_r * Nppc_th;

    unsigned int ir = i_cell / Nx_cell;
    unsigned int ix = i_cell - Nx_cell * ir;
    unsigned int ip = i_cell * Nppc_loc;

    double xmin = xgrid[hook(5, ix)];
    double rmin = rgrid[hook(6, ir)];
    double thmin = theta_var[hook(4, i_cell)];

    double Lx = xgrid[hook(5, ix + 1)] - xgrid[hook(5, ix)];
    double Lr = rgrid[hook(6, ir + 1)] - rgrid[hook(6, ir)];
    double dx = 1. / ((double)Nppc_x);
    double dr = 1. / ((double)Nppc_r);
    double dth = 2 * 3.14159265358979323846f / ((double)Nppc_th);
    double th, rp, sin_th, cos_th, rp_s, rp_c;

    for (unsigned int incell_th = 0; incell_th < Nppc_th; incell_th++) {
      th = thmin + incell_th * dth;
      sin_th = sin(th);
      cos_th = cos(th);
      for (int incell_r = 0; incell_r < Nppc_r; incell_r++) {
        rp = rmin + (0.5 + incell_r) * dr * Lr;
        rp_s = rp * sin_th;
        rp_c = rp * cos_th;
        for (int incell_x = 0; incell_x < Nppc_x; incell_x++) {
          x[hook(0, ip)] = xmin + (0.5 + incell_x) * dx * Lx;
          y[hook(1, ip)] = rp_s;
          z[hook(2, ip)] = rp_c;
          w[hook(3, ip)] = rp;
          ip += 1;
        }
      }
    }
  }
}