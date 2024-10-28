//{"a":0,"arr_size":5,"b":2,"x":1,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void axpbyz_c2c(double2 a, global double2* x, double2 b, global double2* y, global double2* z, unsigned int arr_size) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < arr_size) {
    z[hook(4, i_cell)].s0 = a.s0 * x[hook(1, i_cell)].s0 - a.s1 * x[hook(1, i_cell)].s1 + b.s0 * y[hook(3, i_cell)].s0 - b.s1 * y[hook(3, i_cell)].s1;

    z[hook(4, i_cell)].s1 = a.s0 * x[hook(1, i_cell)].s1 + a.s1 * x[hook(1, i_cell)].s0 + b.s0 * y[hook(3, i_cell)].s1 + b.s1 * y[hook(3, i_cell)].s0;
  }
}