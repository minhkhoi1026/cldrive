//{"current_dist_matrix":1,"num_training_patterns":2,"patt_current_row":3,"training_patterns":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_compute_distance_matrix(global float* training_patterns, global float* current_dist_matrix, int num_training_patterns) {
  int tid = get_global_id(0);
  if (tid >= num_training_patterns) {
    return;
  }

  int j, k;

  float patt_current_row[3];
  for (k = 3; k--;) {
    patt_current_row[hook(3, k)] = training_patterns[hook(0, k * num_training_patterns + tid)];
  }

  float tmp;
  float dist_tmp;

  for (j = 0; j < num_training_patterns; j++) {
    dist_tmp = 0.0;

    for (k = 3; k--;) {
      tmp = patt_current_row[hook(3, k)] - training_patterns[hook(0, k * num_training_patterns + j)];
      dist_tmp += tmp * tmp;
    }

    current_dist_matrix[hook(1, j * num_training_patterns + tid)] = dist_tmp;
  }
}