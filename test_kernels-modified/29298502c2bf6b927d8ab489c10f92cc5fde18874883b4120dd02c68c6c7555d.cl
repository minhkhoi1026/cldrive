//{"C_cell":27,"C_cell[0]":26,"C_cell[1]":28,"C_cell[i]":29,"Nr":15,"Nx":12,"NxNr_4":18,"cell_offset":0,"charge":11,"dr_inv":17,"dx_inv":14,"g_inv":8,"indx_offset":10,"jp":25,"rmin":16,"sorting_indx":1,"ux":5,"uy":6,"uz":7,"vec_cell_m0":24,"vec_cell_m0[0]":31,"vec_cell_m0[0][i]":30,"vec_cell_m0[1]":33,"vec_cell_m0[1][i]":32,"vec_cell_m0[2]":35,"vec_cell_m0[2][i]":34,"vec_cell_m0[k]":23,"vec_cell_m0[k][i]":22,"vec_x_m0":19,"vec_y_m0":20,"vec_z_m0":21,"w":9,"x":2,"xmin":13,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void depose_vector(unsigned int cell_offset, global unsigned int* sorting_indx, global double* x, global double* y, global double* z, global double* ux, global double* uy, global double* uz, global double* g_inv, global double* w, global unsigned int* indx_offset, char charge, constant unsigned int* Nx, constant double* xmin, constant double* dx_inv, constant unsigned int* Nr, constant double* rmin, constant double* dr_inv, constant unsigned int* NxNr_4, global double* vec_x_m0, global double* vec_y_m0, global double* vec_z_m0) {
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

    if (ix > 0 && ix < Nx_cell - 1 && ir < Nr_cell - 1 && ir >= 0) {
      unsigned int i_cell_glob = ix + ir * Nx_cell;
      unsigned int i_grid_glob = ix + ir * Nx_grid;

      unsigned int ip_start = indx_offset[hook(10, i_cell_glob)];
      unsigned int ip_end = indx_offset[hook(10, i_cell_glob + 1)];

      if (ip_start != ip_end) {
        double vec_cell_m0[3][2][2];

        for (int k = 0; k < 3; k++) {
          for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
              vec_cell_m0[hook(24, k)][hook(23, i)][hook(22, j)] = 0;
            }
          }
        }

        double sX0, sX1, sR0, sR1;
        double C_cell[2][2];

        double xp, yp, zp, wp, rp;
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
          jp[hook(25, 0)] = ux[hook(5, ip_srtd)];
          jp[hook(25, 1)] = uy[hook(6, ip_srtd)];
          jp[hook(25, 2)] = uz[hook(7, ip_srtd)];
          wp = w[hook(9, ip_srtd)] * g_inv[hook(8, ip_srtd)] * charge;

          rp = sqrt(yp * yp + zp * zp);

          sX1 = (xp - xmin_loc) * dx_inv_loc - ix;
          sX0 = 1.0 - sX1;
          sR1 = (rp - rmin_loc) * dr_inv_loc - ir;
          sR0 = 1.0 - sR1;

          sX0 *= wp;
          sX1 *= wp;

          C_cell[hook(27, 0)][hook(26, 0)] = sR0 * sX0;
          C_cell[hook(27, 0)][hook(26, 1)] = sR0 * sX1;
          C_cell[hook(27, 1)][hook(28, 0)] = sR1 * sX0;
          C_cell[hook(27, 1)][hook(28, 1)] = sR1 * sX1;

          for (int k = 0; k < 3; k++) {
            for (int i = 0; i < 2; i++) {
              for (int j = 0; j < 2; j++) {
                vec_cell_m0[hook(24, k)][hook(23, i)][hook(22, j)] += C_cell[hook(27, i)][hook(29, j)] * jp[hook(25, k)];
              }
            }
          }
        }

        for (int i = 0; i < 2; i++) {
          for (int j = 0; j < 2; j++) {
            int i_dep = i_grid_glob + j + Nx_grid * i;
            vec_x_m0[hook(19, i_dep)] += vec_cell_m0[hook(24, 0)][hook(31, i)][hook(30, j)];
            vec_y_m0[hook(20, i_dep)] += vec_cell_m0[hook(24, 1)][hook(33, i)][hook(32, j)];
            vec_z_m0[hook(21, i_dep)] += vec_cell_m0[hook(24, 2)][hook(35, i)][hook(34, j)];
          }
        }
      }
    }
  }
}