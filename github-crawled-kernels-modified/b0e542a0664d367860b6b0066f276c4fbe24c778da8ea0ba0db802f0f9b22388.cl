//{"current_dist_matrix":1,"min_dim":3,"mult":4,"num_training_patterns":2,"training_patterns":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_update_current_distance_matrix(global float* training_patterns, global float* current_dist_matrix, int num_training_patterns, int min_dim, int mult) {
  int tid = get_global_id(0);
  if (tid >= num_training_patterns) {
    return;
  }

  int j;

  float patt_current_row_dim_removed = training_patterns[hook(0, min_dim * num_training_patterns + tid)];

  float tmp;

  for (j = 0; j < num_training_patterns; j++) {
    tmp = patt_current_row_dim_removed - training_patterns[hook(0, min_dim * num_training_patterns + j)];

    current_dist_matrix[hook(1, j * num_training_patterns + tid)] = current_dist_matrix[hook(1, j * num_training_patterns + tid)] + mult * tmp * tmp;
  }
}