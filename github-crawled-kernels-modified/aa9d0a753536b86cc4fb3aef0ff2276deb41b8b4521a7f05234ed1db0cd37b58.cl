//{"dst":0,"end_address":5,"final_x_size":1,"final_y_size":2,"final_z_size":3,"start_address":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_thread_dimension_atomic(global unsigned int* dst, unsigned int final_x_size, unsigned int final_y_size, unsigned int final_z_size, unsigned int start_address, unsigned int end_address) {
  unsigned int error = 0;
  if (get_global_id(0) >= final_x_size)
    error = 64;
  if (get_global_id(1) >= final_y_size)
    error = 128;
  if (get_global_id(2) >= final_z_size)
    error = 256;

  unsigned int t_address = (unsigned int)get_global_id(2) * (unsigned int)final_y_size * (unsigned int)final_x_size + (unsigned int)get_global_id(1) * (unsigned int)final_x_size + (unsigned int)get_global_id(0);
  if ((t_address >= start_address) && (t_address < end_address))
    atom_add(&dst[hook(0, t_address - start_address)], 1u);
  if (error)
    atom_or(&dst[hook(0, t_address - start_address)], error);
}