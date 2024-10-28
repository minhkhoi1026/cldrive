//{"arr_add":1,"arr_base":0,"arr_size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void append_c2c(global double2* arr_base, global double2* arr_add, unsigned int arr_size) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < arr_size) {
    arr_base[hook(0, i_cell)].s0 = arr_base[hook(0, i_cell)].s0 + arr_add[hook(1, i_cell)].s0;
    arr_base[hook(0, i_cell)].s1 = arr_base[hook(0, i_cell)].s1 + arr_add[hook(1, i_cell)].s1;
  }
}