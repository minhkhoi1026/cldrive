//{"cell_offset":0,"indx_in_cell":1,"new_sum_in_cell":2,"num_p":4,"sorted_indx":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sort(global unsigned int* cell_offset, global unsigned int* indx_in_cell, global unsigned int* new_sum_in_cell, global unsigned int* sorted_indx, unsigned int num_p) {
  unsigned int ip = (unsigned int)get_global_id(0);
  if (ip < num_p) {
    unsigned int i_cell = indx_in_cell[hook(1, ip)];
    unsigned int ip_offset_loc = atom_add(&new_sum_in_cell[hook(2, i_cell)], 1U);
    unsigned int ip_sorted = cell_offset[hook(0, i_cell)] + ip_offset_loc;
    sorted_indx[hook(3, ip_sorted)] = ip;
  }
}