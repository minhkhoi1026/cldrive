//{"Nr":9,"Nx":6,"dr_inv":11,"dx_inv":8,"indx_in_cell":5,"num_p":4,"rmin":10,"sum_in_cell":3,"x":0,"xmin":7,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void index_and_sum_in_cell(global double* x, global double* y, global double* z, global unsigned int* sum_in_cell, constant unsigned int* num_p, global unsigned int* indx_in_cell, constant unsigned int* Nx, constant double* xmin, constant double* dx_inv, constant unsigned int* Nr, constant double* rmin, constant double* dr_inv) {
  unsigned int ip = (unsigned int)get_global_id(0);
  if (ip < *num_p) {
    double r;
    int ix, ir;
    int Nx_loc = (int)*Nx - 1;
    int Nr_loc = (int)*Nr - 1;

    r = sqrt(y[hook(1, ip)] * y[hook(1, ip)] + z[hook(2, ip)] * z[hook(2, ip)]);

    ix = (int)floor((x[hook(0, ip)] - *xmin) * (*dx_inv));
    ir = (int)floor((r - *rmin) * (*dr_inv));

    if (ix > 0 && ix < Nx_loc - 1 && ir < Nr_loc - 1 && ir >= 0) {
      indx_in_cell[hook(5, ip)] = ix + ir * Nx_loc;
      atom_add(&sum_in_cell[hook(3, indx_in_cell[ihook(5, ip))], 1U);
    } else {
      indx_in_cell[hook(5, ip)] = Nr_loc * Nx_loc;
      atom_add(&sum_in_cell[hook(3, indx_in_cell[ihook(5, ip))], 1U);
    }
  }
}