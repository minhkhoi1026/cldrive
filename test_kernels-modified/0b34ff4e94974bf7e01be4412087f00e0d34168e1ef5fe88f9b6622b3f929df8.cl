//{"C_cell":26,"C_cell[0]":25,"C_cell[1]":27,"C_cell[i]":44,"Np":10,"Np_stay":11,"Nr":15,"Nx":12,"Nxm1Nrm1":18,"b_cell_m0":37,"b_cell_m0[0]":36,"b_cell_m0[0][i]":35,"b_cell_m0[1]":39,"b_cell_m0[1][i]":38,"b_cell_m0[2]":41,"b_cell_m0[2][i]":40,"b_cell_m0[k]":48,"b_cell_m0[k][i]":47,"b_p":43,"bx_m0":22,"by_m0":23,"bz_m0":24,"dr_inv":17,"dt":9,"dx_inv":14,"e_cell_m0":30,"e_cell_m0[0]":29,"e_cell_m0[0][i]":28,"e_cell_m0[1]":32,"e_cell_m0[1][i]":31,"e_cell_m0[2]":34,"e_cell_m0[2][i]":33,"e_cell_m0[k]":46,"e_cell_m0[k][i]":45,"e_p":42,"ex_m0":19,"ey_m0":20,"ez_m0":21,"g_inv":6,"indx_offset":8,"px":3,"py":4,"pz":5,"rmin":16,"s":52,"sorting_indx":7,"t":51,"u0":53,"u_p":50,"um":49,"up":54,"x":0,"xmin":13,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gather_and_push(global double* x, global double* y, global double* z, global double* px, global double* py, global double* pz, global double* g_inv, global unsigned int* sorting_indx, global unsigned int* indx_offset, constant double* dt, unsigned int Np, unsigned int Np_stay, constant unsigned int* Nx, constant double* xmin, constant double* dx_inv, constant unsigned int* Nr, constant double* rmin, constant double* dr_inv, constant unsigned int* Nxm1Nrm1, global double* ex_m0, global double* ey_m0, global double* ez_m0, global double* bx_m0, global double* by_m0, global double* bz_m0) {
  unsigned int ip = (unsigned int)get_global_id(0);
  if (ip < Np) {
    unsigned int ip_srtd = sorting_indx[hook(7, ip)];
    if (ip_srtd < Np_stay) {
      int Nx_grid = (int)*Nx;
      int Nx_cell = Nx_grid - 1;
      int Nr_cell = (int)*Nr - 1;

      double xp = x[hook(0, ip_srtd)];
      double yp = y[hook(1, ip_srtd)];
      double zp = z[hook(2, ip_srtd)];
      double rp = sqrt(yp * yp + zp * zp);

      double xmin_loc = *xmin;
      double rmin_loc = *rmin;
      double dr_inv_loc = *dr_inv;
      double dx_inv_loc = *dx_inv;

      int ix = (int)floor((xp - xmin_loc) * dx_inv_loc);
      int ir = (int)floor((rp - rmin_loc) * dr_inv_loc);

      if (ix > 0 && ix < Nx_cell - 1 && ir < Nr_cell - 1) {
        double u_p[3] = {px[hook(3, ip_srtd)], py[hook(4, ip_srtd)], pz[hook(5, ip_srtd)]};
        double dt_2 = 0.5 * (*dt);
        double rp_inv = 1. / rp;

        unsigned int i_cell = ix + ir * Nx_cell;
        unsigned int i_grid = ix + ir * Nx_grid;

        double sX1 = (xp - xmin_loc) * dx_inv_loc - ix;
        double sX0 = 1.0 - sX1;
        double sR1 = (rp - rmin_loc) * dr_inv_loc - ir;
        double sR0 = 1.0 - sR1;

        double C_cell[2][2];

        C_cell[hook(26, 0)][hook(25, 0)] = sR0 * sX0;
        C_cell[hook(26, 0)][hook(25, 1)] = sR0 * sX1;
        C_cell[hook(26, 1)][hook(27, 0)] = sR1 * sX0;
        C_cell[hook(26, 1)][hook(27, 1)] = sR1 * sX1;

        unsigned int i, j, k, i_loc;

        double e_cell_m0[3][2][2];
        double b_cell_m0[3][2][2];

        for (i = 0; i < 2; i++) {
          for (j = 0; j < 2; j++) {
            i_loc = i_grid + j + Nx_grid * i;
            e_cell_m0[hook(30, 0)][hook(29, i)][hook(28, j)] = ex_m0[hook(19, i_loc)];
            e_cell_m0[hook(30, 1)][hook(32, i)][hook(31, j)] = ey_m0[hook(20, i_loc)];
            e_cell_m0[hook(30, 2)][hook(34, i)][hook(33, j)] = ez_m0[hook(21, i_loc)];

            b_cell_m0[hook(37, 0)][hook(36, i)][hook(35, j)] = bx_m0[hook(22, i_loc)];
            b_cell_m0[hook(37, 1)][hook(39, i)][hook(38, j)] = by_m0[hook(23, i_loc)];
            b_cell_m0[hook(37, 2)][hook(41, i)][hook(40, j)] = bz_m0[hook(24, i_loc)];
          }
        }

        double e_p[3], b_p[3];
        for (k = 0; k < 3; k++) {
          e_p[hook(42, k)] = 0;
          b_p[hook(43, k)] = 0;
        }

        for (k = 0; k < 3; k++) {
          for (i = 0; i < 2; i++) {
            for (j = 0; j < 2; j++) {
              e_p[hook(42, k)] += C_cell[hook(26, i)][hook(44, j)] * e_cell_m0[hook(30, k)][hook(46, i)][hook(45, j)];
              b_p[hook(43, k)] += C_cell[hook(26, i)][hook(44, j)] * b_cell_m0[hook(37, k)][hook(48, i)][hook(47, j)];
            }
          }
        }

        double um[3], up[3], u0[3], t[3], s[3];

        for (k = 0; k < 3; k++) {
          um[hook(49, k)] = u_p[hook(50, k)] + dt_2 * e_p[hook(42, k)];
        }

        double g_p_inv = 1. / sqrt(1. + um[hook(49, 0)] * um[hook(49, 0)] + um[hook(49, 1)] * um[hook(49, 1)] + um[hook(49, 2)] * um[hook(49, 2)]);

        for (k = 0; k < 3; k++) {
          t[hook(51, k)] = dt_2 * b_p[hook(43, k)] * g_p_inv;
        }

        double t2p1_m1_05 = 2. / (1. + t[hook(51, 0)] * t[hook(51, 0)] + t[hook(51, 1)] * t[hook(51, 1)] + t[hook(51, 2)] * t[hook(51, 2)]);

        for (k = 0; k < 3; k++) {
          s[hook(52, k)] = t[hook(51, k)] * t2p1_m1_05;
        }

        u0[hook(53, 0)] = um[hook(49, 0)] + um[hook(49, 1)] * t[hook(51, 2)] - um[hook(49, 2)] * t[hook(51, 1)];
        u0[hook(53, 1)] = um[hook(49, 1)] - um[hook(49, 0)] * t[hook(51, 2)] + um[hook(49, 2)] * t[hook(51, 0)];
        u0[hook(53, 2)] = um[hook(49, 2)] + um[hook(49, 0)] * t[hook(51, 1)] - um[hook(49, 1)] * t[hook(51, 0)];

        up[hook(54, 0)] = um[hook(49, 0)] + u0[hook(53, 1)] * s[hook(52, 2)] - u0[hook(53, 2)] * s[hook(52, 1)];
        up[hook(54, 1)] = um[hook(49, 1)] - u0[hook(53, 0)] * s[hook(52, 2)] + u0[hook(53, 2)] * s[hook(52, 0)];
        up[hook(54, 2)] = um[hook(49, 2)] + u0[hook(53, 0)] * s[hook(52, 1)] - u0[hook(53, 1)] * s[hook(52, 0)];

        for (int k = 0; k < 3; k++) {
          u_p[hook(50, k)] = up[hook(54, k)] + dt_2 * e_p[hook(42, k)];
        }

        g_p_inv = 1. / sqrt(1. + u_p[hook(50, 0)] * u_p[hook(50, 0)] + u_p[hook(50, 1)] * u_p[hook(50, 1)] + u_p[hook(50, 2)] * u_p[hook(50, 2)]);

        px[hook(3, ip_srtd)] = u_p[hook(50, 0)];
        py[hook(4, ip_srtd)] = u_p[hook(50, 1)];
        pz[hook(5, ip_srtd)] = u_p[hook(50, 2)];
        g_inv[hook(6, ip_srtd)] = g_p_inv;
      }
    }
  }
}