//{"Nx":2,"NxNr":1,"arr":0,"dv_inv":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void divide_by_dv_c(global double2* arr, constant unsigned int* NxNr, constant unsigned int* Nx, global double* dv_inv) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < *NxNr) {
    unsigned int Nx_loc = *Nx;
    unsigned int ir = i_cell / Nx_loc;
    arr[hook(0, i_cell)].s0 *= dv_inv[hook(3, ir)];
    arr[hook(0, i_cell)].s1 *= dv_inv[hook(3, ir)];
  }
}