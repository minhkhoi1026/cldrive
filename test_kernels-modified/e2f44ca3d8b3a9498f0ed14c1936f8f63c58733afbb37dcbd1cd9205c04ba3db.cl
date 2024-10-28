//{"a":0,"arr_size":3,"x":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void zpaxz_c2c(double2 a, global double2* x, global double2* z, unsigned int arr_size) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < arr_size) {
    z[hook(2, i_cell)].s0 = z[hook(2, i_cell)].s0 + a.s0 * x[hook(1, i_cell)].s0 - a.s1 * x[hook(1, i_cell)].s1;
    z[hook(2, i_cell)].s1 = z[hook(2, i_cell)].s1 + a.s0 * x[hook(1, i_cell)].s1 + a.s1 * x[hook(1, i_cell)].s0;
  }
}