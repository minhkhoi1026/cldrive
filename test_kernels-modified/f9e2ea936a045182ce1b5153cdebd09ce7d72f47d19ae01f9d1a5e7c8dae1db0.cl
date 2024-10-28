//{"C_cell":35,"C_cell[0]":34,"C_cell[1]":36,"C_cell[i]":37,"Nr":15,"Nx":12,"NxNr_4":18,"cell_offset":0,"charge":11,"dr_inv":17,"dx_inv":14,"exp_m1":33,"g_inv":8,"indx_offset":10,"jp":32,"rmin":16,"sorting_indx":1,"ux":5,"uy":6,"uz":7,"vec_cell_m0":27,"vec_cell_m0[0]":39,"vec_cell_m0[0][i]":38,"vec_cell_m0[1]":41,"vec_cell_m0[1][i]":40,"vec_cell_m0[2]":43,"vec_cell_m0[2][i]":42,"vec_cell_m0[k]":26,"vec_cell_m0[k][i]":25,"vec_cell_m1":31,"vec_cell_m1[0]":46,"vec_cell_m1[0][i]":45,"vec_cell_m1[0][i][j]":44,"vec_cell_m1[1]":49,"vec_cell_m1[1][i]":48,"vec_cell_m1[1][i][j]":47,"vec_cell_m1[2]":52,"vec_cell_m1[2][i]":51,"vec_cell_m1[2][i][j]":50,"vec_cell_m1[k]":30,"vec_cell_m1[k][i]":29,"vec_cell_m1[k][i][j]":28,"vec_x_m0":19,"vec_x_m1":22,"vec_y_m0":20,"vec_y_m1":23,"vec_z_m0":21,"vec_z_m1":24,"w":9,"x":2,"xmin":13,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void depose_vector(unsigned int cell_offset, global unsigned int* sorting_indx, global double* x, global double* y, global double* z, global double* ux, global double* uy, global double* uz, global double* g_inv, global double* w, global unsigned int* indx_offset, char charge, constant unsigned int* Nx, constant double* xmin, constant double* dx_inv, constant unsigned int* Nr, constant double* rmin, constant double* dr_inv, constant unsigned int* NxNr_4, global double* vec_x_m0, global double* vec_y_m0, global double* vec_z_m0, global double2* vec_x_m1, global double2* vec_y_m1, global double2* vec_z_m1) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < *NxNr_4) {
    unsigned int Nx_grid = *Nx;
    unsigned int Nx_cell = Nx_grid - 1;
    unsigned int Nx_2 = Nx_grid / 2;
    unsigned int Nr_cell = *Nr - 1;

    unsigned int ir = i_cell / Nx_2;
    unsigned int ix = i_cell - ir * Nx_2;

    ix *= 2;
    ir *= 2;

    if (cell_offset == 1) {
      ix += 1;
    } else if (cell_offset == 2) {
      ir += 1;
    } else if (cell_offset == 3) {
      ix += 1;
      ir += 1;
    }

    if (ix > 0 && ix < Nx_cell - 1 && ir < Nr_cell - 1) {
      unsigned int i_cell_glob = ix + ir * Nx_cell;
      unsigned int i_grid_glob = ix + ir * Nx_grid;

      unsigned int ip_start = indx_offset[hook(10, i_cell_glob)];
      unsigned int ip_end = indx_offset[hook(10, i_cell_glob + 1)];

      if (ip_start != ip_end) {
        unsigned int i, j, k, i_dep;

        double vec_cell_m0[3][2][2];
        double vec_cell_m1[3][2][2][2];

        for (k = 0; k < 3; k++) {
          for (i = 0; i < 2; i++) {
            for (j = 0; j < 2; j++) {
              vec_cell_m0[hook(27, k)][hook(26, i)][hook(25, j)] = 0.;
              vec_cell_m1[hook(31, k)][hook(30, i)][hook(29, j)][hook(28, 0)] = 0.;
              vec_cell_m1[hook(31, k)][hook(30, i)][hook(29, j)][hook(28, 1)] = 0.;
            }
          }
        }

        double sX0, sX1, sR0, sR1;
        double C_cell[2][2];
        double exp_m1[2];

        double xp, yp, zp, wp, rp, rp_inv, jp_proj;
        double jp[3];
        double rmin_loc = *rmin;
        double dr_inv_loc = *dr_inv;
        double xmin_loc = *xmin;
        double dx_inv_loc = *dx_inv;
        unsigned int ip_srtd;

        for (unsigned int ip = ip_start; ip < ip_end; ip++) {
          ip_srtd = sorting_indx[hook(1, ip)];
          xp = x[hook(2, ip_srtd)];
          yp = y[hook(3, ip_srtd)];
          zp = z[hook(4, ip_srtd)];
          jp[hook(32, 0)] = ux[hook(5, ip_srtd)];
          jp[hook(32, 1)] = uy[hook(6, ip_srtd)];
          jp[hook(32, 2)] = uz[hook(7, ip_srtd)];
          wp = w[hook(9, ip_srtd)] * g_inv[hook(8, ip_srtd)] * charge;

          rp = sqrt(yp * yp + zp * zp);

          rp_inv = 0;
          if (rp > 0) {
            rp_inv = 1. / rp;
          }

          exp_m1[hook(33, 0)] = yp * rp_inv;
          exp_m1[hook(33, 1)] = zp * rp_inv;

          sX1 = (xp - xmin_loc) * dx_inv_loc - ix;
          sX0 = 1.0 - sX1;
          sR1 = (rp - rmin_loc) * dr_inv_loc - ir;
          sR0 = 1.0 - sR1;

          sX0 *= wp;
          sX1 *= wp;

          C_cell[hook(35, 0)][hook(34, 0)] = sR0 * sX0;
          C_cell[hook(35, 0)][hook(34, 1)] = sR0 * sX1;
          C_cell[hook(35, 1)][hook(36, 0)] = sR1 * sX0;
          C_cell[hook(35, 1)][hook(36, 1)] = sR1 * sX1;

          for (k = 0; k < 3; k++) {
            for (i = 0; i < 2; i++) {
              for (j = 0; j < 2; j++) {
                jp_proj = C_cell[hook(35, i)][hook(37, j)] * jp[hook(32, k)];
                vec_cell_m0[hook(27, k)][hook(26, i)][hook(25, j)] += C_cell[hook(35, i)][hook(37, j)] * jp[hook(32, k)];
                vec_cell_m1[hook(31, k)][hook(30, i)][hook(29, j)][hook(28, 0)] += jp_proj * exp_m1[hook(33, 0)];
                vec_cell_m1[hook(31, k)][hook(30, i)][hook(29, j)][hook(28, 1)] += jp_proj * exp_m1[hook(33, 1)];
              }
            }
          }
        }

        for (i = 0; i < 2; i++) {
          for (j = 0; j < 2; j++) {
            i_dep = i_grid_glob + j + Nx_grid * i;

            vec_x_m0[hook(19, i_dep)] = vec_x_m0[hook(19, i_dep)] + vec_cell_m0[hook(27, 0)][hook(39, i)][hook(38, j)];
            vec_y_m0[hook(20, i_dep)] = vec_y_m0[hook(20, i_dep)] + vec_cell_m0[hook(27, 1)][hook(41, i)][hook(40, j)];
            vec_z_m0[hook(21, i_dep)] = vec_z_m0[hook(21, i_dep)] + vec_cell_m0[hook(27, 2)][hook(43, i)][hook(42, j)];

            vec_x_m1[hook(22, i_dep)] = vec_x_m1[hook(22, i_dep)] + (double2){vec_cell_m1[hook(31, 0)][hook(46, i)][hook(45, j)][hook(44, 0)], vec_cell_m1[hook(31, 0)][hook(46, i)][hook(45, j)][hook(44, 1)]};
            vec_y_m1[hook(23, i_dep)] = vec_y_m1[hook(23, i_dep)] + (double2){vec_cell_m1[hook(31, 1)][hook(49, i)][hook(48, j)][hook(47, 0)], vec_cell_m1[hook(31, 1)][hook(49, i)][hook(48, j)][hook(47, 1)]};
            vec_z_m1[hook(24, i_dep)] = vec_z_m1[hook(24, i_dep)] + (double2){vec_cell_m1[hook(31, 2)][hook(52, i)][hook(51, j)][hook(50, 0)], vec_cell_m1[hook(31, 2)][hook(52, i)][hook(51, j)][hook(50, 1)]};
          }
        }
      }
    }
  }
}