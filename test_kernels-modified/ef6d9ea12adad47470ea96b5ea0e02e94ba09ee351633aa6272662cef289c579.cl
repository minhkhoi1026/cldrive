//{"Nx":2,"NxNr":1,"arr":0,"phs_shft":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multiply_by_phase(global double2* arr, constant unsigned int* NxNr, constant unsigned int* Nx, global double2* phs_shft) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < *NxNr) {
    unsigned int Nx_loc = *Nx;
    unsigned int ir = i_cell / Nx_loc;
    unsigned int ix = i_cell - ir * Nx_loc;

    double arr_re = arr[hook(0, i_cell)].s0;
    double arr_im = arr[hook(0, i_cell)].s1;

    double phs_re = phs_shft[hook(3, ix)].s0;
    double phs_im = phs_shft[hook(3, ix)].s1;

    arr[hook(0, i_cell)].s0 = (arr_re * phs_re - arr_im * phs_im);
    arr[hook(0, i_cell)].s1 = (arr_re * phs_im + arr_im * phs_re);
  }
}