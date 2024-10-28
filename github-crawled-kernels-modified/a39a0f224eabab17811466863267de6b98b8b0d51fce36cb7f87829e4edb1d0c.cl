//{"C_cell":33,"C_cell[0]":32,"C_cell[1]":34,"C_cell[i]":71,"Np":10,"Np_stay":11,"Nr":15,"Nx":12,"Nxm1Nrm1":18,"b_cell_m0":44,"b_cell_m0[0]":43,"b_cell_m0[0][i]":42,"b_cell_m0[1]":46,"b_cell_m0[1][i]":45,"b_cell_m0[2]":48,"b_cell_m0[2][i]":47,"b_cell_m0[k]":75,"b_cell_m0[k][i]":74,"b_cell_m1":62,"b_cell_m1[0]":61,"b_cell_m1[0][i]":60,"b_cell_m1[0][i][j]":59,"b_cell_m1[1]":65,"b_cell_m1[1][i]":64,"b_cell_m1[1][i][j]":63,"b_cell_m1[2]":68,"b_cell_m1[2][i]":67,"b_cell_m1[2][i][j]":66,"b_cell_m1[k]":81,"b_cell_m1[k][i]":80,"b_cell_m1[k][i][j]":79,"b_p":70,"bx_m0":22,"bx_m1":28,"by_m0":23,"by_m1":29,"bz_m0":24,"bz_m1":30,"dr_inv":17,"dt":9,"dx_inv":14,"e_cell_m0":37,"e_cell_m0[0]":36,"e_cell_m0[0][i]":35,"e_cell_m0[1]":39,"e_cell_m0[1][i]":38,"e_cell_m0[2]":41,"e_cell_m0[2][i]":40,"e_cell_m0[k]":73,"e_cell_m0[k][i]":72,"e_cell_m1":52,"e_cell_m1[0]":51,"e_cell_m1[0][i]":50,"e_cell_m1[0][i][j]":49,"e_cell_m1[1]":55,"e_cell_m1[1][i]":54,"e_cell_m1[1][i][j]":53,"e_cell_m1[2]":58,"e_cell_m1[2][i]":57,"e_cell_m1[2][i][j]":56,"e_cell_m1[k]":78,"e_cell_m1[k][i]":77,"e_cell_m1[k][i][j]":76,"e_p":69,"ex_m0":19,"ex_m1":25,"exp_m1":31,"ey_m0":20,"ey_m1":26,"ez_m0":21,"ez_m1":27,"g_inv":6,"indx_offset":8,"px":3,"py":4,"pz":5,"rmin":16,"s":85,"sorting_indx":7,"t":84,"u0":86,"u_p":83,"um":82,"up":87,"x":0,"xmin":13,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gather_and_push(global double* x, global double* y, global double* z, global double* px, global double* py, global double* pz, global double* g_inv, global unsigned int* sorting_indx, global unsigned int* indx_offset, constant double* dt, unsigned int Np, unsigned int Np_stay, constant unsigned int* Nx, constant double* xmin, constant double* dx_inv, constant unsigned int* Nr, constant double* rmin, constant double* dr_inv, constant unsigned int* Nxm1Nrm1, global double* ex_m0, global double* ey_m0, global double* ez_m0, global double* bx_m0, global double* by_m0, global double* bz_m0, global double2* ex_m1, global double2* ey_m1, global double2* ez_m1, global double2* bx_m1, global double2* by_m1, global double2* bz_m1) {
  unsigned int ip = (unsigned int)get_global_id(0);
  if (ip < Np) {
    unsigned int ip_srtd = sorting_indx[hook(7, ip)];
    if (ip_srtd < Np_stay) {
      int Nx_grid = (int)*Nx;
      int Nx_cell = Nx_grid - 1;
      int Nr_cell = (int)*Nr - 1;

      double xmin_loc = *xmin;
      double rmin_loc = *rmin;
      double dr_inv_loc = *dr_inv;
      double dx_inv_loc = *dx_inv;

      double xp = x[hook(0, ip_srtd)];
      double yp = y[hook(1, ip_srtd)];
      double zp = z[hook(2, ip_srtd)];
      double rp = sqrt(yp * yp + zp * zp);

      int ix = (int)floor((xp - xmin_loc) * dx_inv_loc);
      int ir = (int)floor((rp - rmin_loc) * dr_inv_loc);

      if (ix > 0 && ix < Nx_cell - 1 && ir < Nr_cell - 1) {
        unsigned int i_cell = ix + ir * Nx_cell;
        unsigned int i_grid = ix + ir * Nx_grid;

        double u_p[3] = {px[hook(3, ip_srtd)], py[hook(4, ip_srtd)], pz[hook(5, ip_srtd)]};
        double dt_2 = 0.5 * (*dt);
        double rp_inv = 1. / rp;

        double sX1 = (xp - xmin_loc) * dx_inv_loc - ix;
        double sX0 = 1.0 - sX1;
        double sR1 = (rp - rmin_loc) * dr_inv_loc - ir;
        double sR0 = 1.0 - sR1;

        double C_cell[2][2];
        double exp_m1[2];

        exp_m1[hook(31, 0)] = yp * rp_inv;
        exp_m1[hook(31, 1)] = -zp * rp_inv;

        C_cell[hook(33, 0)][hook(32, 0)] = sR0 * sX0;
        C_cell[hook(33, 0)][hook(32, 1)] = sR0 * sX1;
        C_cell[hook(33, 1)][hook(34, 0)] = sR1 * sX0;
        C_cell[hook(33, 1)][hook(34, 1)] = sR1 * sX1;

        unsigned int i, j, k, i_loc;

        double e_cell_m0[3][2][2];
        double b_cell_m0[3][2][2];
        double e_cell_m1[3][2][2][2];
        double b_cell_m1[3][2][2][2];

        for (i = 0; i < 2; i++) {
          for (j = 0; j < 2; j++) {
            i_loc = i_grid + j + Nx_grid * i;
            e_cell_m0[hook(37, 0)][hook(36, i)][hook(35, j)] = ex_m0[hook(19, i_loc)];
            e_cell_m0[hook(37, 1)][hook(39, i)][hook(38, j)] = ey_m0[hook(20, i_loc)];
            e_cell_m0[hook(37, 2)][hook(41, i)][hook(40, j)] = ez_m0[hook(21, i_loc)];

            b_cell_m0[hook(44, 0)][hook(43, i)][hook(42, j)] = bx_m0[hook(22, i_loc)];
            b_cell_m0[hook(44, 1)][hook(46, i)][hook(45, j)] = by_m0[hook(23, i_loc)];
            b_cell_m0[hook(44, 2)][hook(48, i)][hook(47, j)] = bz_m0[hook(24, i_loc)];

            e_cell_m1[hook(52, 0)][hook(51, i)][hook(50, j)][hook(49, 0)] = 2 * ((double)ex_m1[hook(25, i_loc)].s0);
            e_cell_m1[hook(52, 0)][hook(51, i)][hook(50, j)][hook(49, 1)] = 2 * ((double)ex_m1[hook(25, i_loc)].s1);

            e_cell_m1[hook(52, 1)][hook(55, i)][hook(54, j)][hook(53, 0)] = 2 * ((double)ey_m1[hook(26, i_loc)].s0);
            e_cell_m1[hook(52, 1)][hook(55, i)][hook(54, j)][hook(53, 1)] = 2 * ((double)ey_m1[hook(26, i_loc)].s1);

            e_cell_m1[hook(52, 2)][hook(58, i)][hook(57, j)][hook(56, 0)] = 2 * ((double)ez_m1[hook(27, i_loc)].s0);
            e_cell_m1[hook(52, 2)][hook(58, i)][hook(57, j)][hook(56, 1)] = 2 * ((double)ez_m1[hook(27, i_loc)].s1);

            b_cell_m1[hook(62, 0)][hook(61, i)][hook(60, j)][hook(59, 0)] = 2 * ((double)bx_m1[hook(28, i_loc)].s0);
            b_cell_m1[hook(62, 0)][hook(61, i)][hook(60, j)][hook(59, 1)] = 2 * ((double)bx_m1[hook(28, i_loc)].s1);

            b_cell_m1[hook(62, 1)][hook(65, i)][hook(64, j)][hook(63, 0)] = 2 * ((double)by_m1[hook(29, i_loc)].s0);
            b_cell_m1[hook(62, 1)][hook(65, i)][hook(64, j)][hook(63, 1)] = 2 * ((double)by_m1[hook(29, i_loc)].s1);

            b_cell_m1[hook(62, 2)][hook(68, i)][hook(67, j)][hook(66, 0)] = 2 * ((double)bz_m1[hook(30, i_loc)].s0);
            b_cell_m1[hook(62, 2)][hook(68, i)][hook(67, j)][hook(66, 1)] = 2 * ((double)bz_m1[hook(30, i_loc)].s1);
          }
        }

        double e_p[3], b_p[3];
        for (k = 0; k < 3; k++) {
          e_p[hook(69, k)] = 0;
          b_p[hook(70, k)] = 0;
        }

        for (k = 0; k < 3; k++) {
          for (i = 0; i < 2; i++) {
            for (j = 0; j < 2; j++) {
              e_p[hook(69, k)] += C_cell[hook(33, i)][hook(71, j)] * e_cell_m0[hook(37, k)][hook(73, i)][hook(72, j)];
              b_p[hook(70, k)] += C_cell[hook(33, i)][hook(71, j)] * b_cell_m0[hook(44, k)][hook(75, i)][hook(74, j)];

              e_p[hook(69, k)] += C_cell[hook(33, i)][hook(71, j)] * e_cell_m1[hook(52, k)][hook(78, i)][hook(77, j)][hook(76, 0)] * exp_m1[hook(31, 0)];
              e_p[hook(69, k)] -= C_cell[hook(33, i)][hook(71, j)] * e_cell_m1[hook(52, k)][hook(78, i)][hook(77, j)][hook(76, 1)] * exp_m1[hook(31, 1)];
              b_p[hook(70, k)] += C_cell[hook(33, i)][hook(71, j)] * b_cell_m1[hook(62, k)][hook(81, i)][hook(80, j)][hook(79, 0)] * exp_m1[hook(31, 0)];
              b_p[hook(70, k)] -= C_cell[hook(33, i)][hook(71, j)] * b_cell_m1[hook(62, k)][hook(81, i)][hook(80, j)][hook(79, 1)] * exp_m1[hook(31, 1)];
            }
          }
        }

        double um[3], up[3], u0[3], t[3], s[3];

        for (k = 0; k < 3; k++) {
          um[hook(82, k)] = u_p[hook(83, k)] + dt_2 * e_p[hook(69, k)];
        }

        double g_p_inv = 1. / sqrt(1. + um[hook(82, 0)] * um[hook(82, 0)] + um[hook(82, 1)] * um[hook(82, 1)] + um[hook(82, 2)] * um[hook(82, 2)]);

        for (k = 0; k < 3; k++) {
          t[hook(84, k)] = dt_2 * b_p[hook(70, k)] * g_p_inv;
        }

        double t2p1_m1_05 = 2. / (1. + t[hook(84, 0)] * t[hook(84, 0)] + t[hook(84, 1)] * t[hook(84, 1)] + t[hook(84, 2)] * t[hook(84, 2)]);

        for (k = 0; k < 3; k++) {
          s[hook(85, k)] = t[hook(84, k)] * t2p1_m1_05;
        }

        u0[hook(86, 0)] = um[hook(82, 0)] + um[hook(82, 1)] * t[hook(84, 2)] - um[hook(82, 2)] * t[hook(84, 1)];
        u0[hook(86, 1)] = um[hook(82, 1)] - um[hook(82, 0)] * t[hook(84, 2)] + um[hook(82, 2)] * t[hook(84, 0)];
        u0[hook(86, 2)] = um[hook(82, 2)] + um[hook(82, 0)] * t[hook(84, 1)] - um[hook(82, 1)] * t[hook(84, 0)];

        up[hook(87, 0)] = um[hook(82, 0)] + u0[hook(86, 1)] * s[hook(85, 2)] - u0[hook(86, 2)] * s[hook(85, 1)];
        up[hook(87, 1)] = um[hook(82, 1)] - u0[hook(86, 0)] * s[hook(85, 2)] + u0[hook(86, 2)] * s[hook(85, 0)];
        up[hook(87, 2)] = um[hook(82, 2)] + u0[hook(86, 0)] * s[hook(85, 1)] - u0[hook(86, 1)] * s[hook(85, 0)];

        for (int k = 0; k < 3; k++) {
          u_p[hook(83, k)] = up[hook(87, k)] + dt_2 * e_p[hook(69, k)];
        }

        g_p_inv = 1. / sqrt(1. + u_p[hook(83, 0)] * u_p[hook(83, 0)] + u_p[hook(83, 1)] * u_p[hook(83, 1)] + u_p[hook(83, 2)] * u_p[hook(83, 2)]);

        px[hook(3, ip_srtd)] = u_p[hook(83, 0)];
        py[hook(4, ip_srtd)] = u_p[hook(83, 1)];
        pz[hook(5, ip_srtd)] = u_p[hook(83, 2)];
        g_inv[hook(6, ip_srtd)] = g_p_inv;
      }
    }
  }
}