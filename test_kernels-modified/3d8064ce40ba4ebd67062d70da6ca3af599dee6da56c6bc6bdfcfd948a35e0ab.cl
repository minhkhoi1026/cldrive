//{"arr_size":2,"x":0,"z":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult_elementwise_d2c(global double* x, global double2* z, unsigned int arr_size) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < arr_size) {
    z[hook(1, i_cell)].s0 = x[hook(0, i_cell)] * z[hook(1, i_cell)].s0;
    z[hook(1, i_cell)].s1 = x[hook(0, i_cell)] * z[hook(1, i_cell)].s1;
  }
}