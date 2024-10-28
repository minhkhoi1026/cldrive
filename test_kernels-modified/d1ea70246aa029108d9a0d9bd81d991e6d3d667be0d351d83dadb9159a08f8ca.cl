//{"current_dist_matrix":1,"num_training_patterns":3,"patt_current_row":4,"selected_dimensions":2,"training_patterns":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_compute_distance_matrix_selected(global float* training_patterns, global float* current_dist_matrix, global int* selected_dimensions, int num_training_patterns) {
  int tid = get_global_id(0);
  if (tid >= num_training_patterns) {
    return;
  }

  int j, k;

  float tmp;
  float dist_tmp;

  float patt_current_row[3];
  for (k = 3; k--;) {
    patt_current_row[hook(4, k)] = training_patterns[hook(0, k * num_training_patterns + tid)];
  }

  for (j = 0; j < num_training_patterns; j++) {
    dist_tmp = 0.0;

    for (k = 3; k--;) {
      if (selected_dimensions[hook(2, k)] == 1) {
        tmp = training_patterns[hook(0, k * num_training_patterns + tid)] - training_patterns[hook(0, k * num_training_patterns + j)];
        dist_tmp += tmp * tmp;
      }
    }

    current_dist_matrix[hook(1, j * num_training_patterns + tid)] = dist_tmp;
  }
}