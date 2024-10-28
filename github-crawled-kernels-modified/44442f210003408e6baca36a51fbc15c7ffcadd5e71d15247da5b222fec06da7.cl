//{"cross_loc":9,"new_x_coord":4,"new_y_coord":5,"num_cities":1,"old_x_coord":2,"old_y_coord":3,"pop_len":0,"prob_crossover":7,"rnd_prob_cross":8,"selected_parents_inx":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void crossover(int pop_len, int num_cities, global const int* old_x_coord, global const int* old_y_coord, global int* new_x_coord, global int* new_y_coord, global int* selected_parents_inx, float prob_crossover, global float* rnd_prob_cross, global int* cross_loc) {
  int tid = get_global_id(0);

  if (tid < pop_len) {
    if (rnd_prob_cross[hook(8, tid)] < prob_crossover) {
      int cross_location = cross_loc[hook(9, tid)];

      int parent_0_loc = selected_parents_inx[hook(6, 2 * tid)];
      int old_base_offset = parent_0_loc * num_cities;
      int new_base_offset = tid * num_cities;

      for (int i = 0; i <= cross_location; i++) {
        new_x_coord[hook(4, new_base_offset + i)] = old_x_coord[hook(2, old_base_offset + i)];
        new_y_coord[hook(5, new_base_offset + i)] = old_y_coord[hook(3, old_base_offset + i)];
      }

      int remaining = num_cities - cross_location - 1;
      int count = 0;
      int parent_1_loc = selected_parents_inx[hook(6, 2 * tid + 1)];
      old_base_offset = parent_1_loc * num_cities;
      new_base_offset = tid * num_cities;

      for (int i = 0; i < num_cities; i++) {
        bool in_child = false;

        for (int j = 0; j <= cross_location; j++) {
          if (new_x_coord[hook(4, new_base_offset + j)] == old_x_coord[hook(2, old_base_offset + i)] && new_y_coord[hook(5, new_base_offset + j)] == old_y_coord[hook(3, old_base_offset + i)]) {
            in_child = true;
            break;
          }
        }

        if (!in_child) {
          count++;
          new_x_coord[hook(4, new_base_offset + cross_location + count)] = old_x_coord[hook(2, old_base_offset + i)];
          new_y_coord[hook(5, new_base_offset + cross_location + count)] = old_y_coord[hook(3, old_base_offset + i)];
        }

        if (count == remaining)
          break;
      }
    }
  }
}