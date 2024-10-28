//{"new_x_coord":4,"new_y_coord":5,"num_cities":1,"old_x_coord":2,"old_y_coord":3,"pop_len":0,"prob_crossover":6,"rnd_prob_cross":7,"selected_parents_inx":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clone_parent(int pop_len, int num_cities, global const int* old_x_coord, global const int* old_y_coord, global int* new_x_coord, global int* new_y_coord, float prob_crossover, global const float* rnd_prob_cross, global const int* selected_parents_inx) {
  int tid = get_global_id(0);

  if (tid < pop_len) {
    if (rnd_prob_cross[hook(7, tid)] >= prob_crossover) {
      int loc = selected_parents_inx[hook(8, 2 * tid)];
      int old_base_offset = loc * num_cities;
      int new_base_offset = tid * num_cities;

      for (int i = 0; i < num_cities; i++) {
        new_x_coord[hook(4, new_base_offset + i)] = old_x_coord[hook(2, old_base_offset + i)];
        new_y_coord[hook(5, new_base_offset + i)] = old_y_coord[hook(3, old_base_offset + i)];
      }
    }
  }
}