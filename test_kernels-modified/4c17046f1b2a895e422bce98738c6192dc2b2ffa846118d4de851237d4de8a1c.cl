//{"arr_in":0,"arr_out":1,"arr_size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cast_array_d2c(global double2* arr_in, global double* arr_out, unsigned int arr_size) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < arr_size) {
    arr_out[hook(1, i_cell)] = arr_in[hook(0, i_cell)].s0;
  }
}