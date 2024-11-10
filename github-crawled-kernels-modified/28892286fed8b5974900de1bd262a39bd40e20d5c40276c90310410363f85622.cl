//{"Nx":1,"arr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void treat_axis_c(global double2* arr, unsigned int Nx) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < Nx) {
    arr[hook(0, i_cell + Nx)].s0 -= arr[hook(0, i_cell)].s0;
    arr[hook(0, i_cell + Nx)].s1 -= arr[hook(0, i_cell)].s1;
  }
}