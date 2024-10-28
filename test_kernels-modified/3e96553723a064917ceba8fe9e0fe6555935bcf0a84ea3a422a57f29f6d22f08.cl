//{"arr_size":2,"val":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_cdouble_to(global double2* x, double2 val, unsigned int arr_size) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < arr_size) {
    x[hook(0, i_cell)].s0 = val.s0;
    x[hook(0, i_cell)].s1 = val.s1;
  }
}