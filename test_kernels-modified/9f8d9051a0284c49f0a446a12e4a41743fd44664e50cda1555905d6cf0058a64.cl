//{"C_cell":17,"C_cell[0]":16,"C_cell[1]":18,"C_cell[i]":21,"Nr":11,"Nx":8,"NxNr_4":14,"cell_offset":0,"charge":7,"dr_inv":13,"dx_inv":10,"indx_offset":6,"rmin":12,"scl_cell_m0":20,"scl_cell_m0[i]":19,"scl_m0":15,"sorting_indx":1,"w":5,"x":2,"xmin":9,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void depose_scalar(unsigned int cell_offset, global unsigned int* sorting_indx, global double* x, global double* y, global double* z, global double* w, global unsigned int* indx_offset, char charge, constant unsigned int* Nx, constant double* xmin, constant double* dx_inv, constant unsigned int* Nr, constant double* rmin, constant double* dr_inv, constant unsigned int* NxNr_4, global double* scl_m0) {
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

      unsigned int ip_start = indx_offset[hook(6, i_cell_glob)];
      unsigned int ip_end = indx_offset[hook(6, i_cell_glob + 1)];

      if (ip_start != ip_end) {
        double scl_cell_m0[2][2] = {{0., 0.}, {0., 0.}};
        double C_cell[2][2];

        double sX0, sX1, sR0, sR1;

        double xp, yp, zp, wp, rp;
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
          wp = w[hook(5, ip_srtd)] * charge;

          rp = sqrt(yp * yp + zp * zp);

          sX1 = (xp - xmin_loc) * dx_inv_loc - ix;
          sX0 = 1.0 - sX1;
          sR1 = (rp - rmin_loc) * dr_inv_loc - ir;
          sR0 = 1.0 - sR1;

          sX0 *= wp;
          sX1 *= wp;

          C_cell[hook(17, 0)][hook(16, 0)] = sR0 * sX0;
          C_cell[hook(17, 0)][hook(16, 1)] = sR0 * sX1;
          C_cell[hook(17, 1)][hook(18, 0)] = sR1 * sX0;
          C_cell[hook(17, 1)][hook(18, 1)] = sR1 * sX1;

          for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
              scl_cell_m0[hook(20, i)][hook(19, j)] += C_cell[hook(17, i)][hook(21, j)];
            }
          }
        }

        for (int i = 0; i < 2; i++) {
          for (int j = 0; j < 2; j++) {
            int i_dep = i_grid_glob + j + Nx_grid * i;
            scl_m0[hook(15, i_dep)] += scl_cell_m0[hook(20, i)][hook(19, j)];
          }
        }
      }
    }
  }
}