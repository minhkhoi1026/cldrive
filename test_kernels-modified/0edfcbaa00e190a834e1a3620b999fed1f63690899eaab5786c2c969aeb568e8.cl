//{"dim_removed":3,"dim_removed_matrix":1,"num_training_patterns":2,"training_patterns":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_dim_removed_matrix(global float* training_patterns, global float* dim_removed_matrix, int num_training_patterns, int dim_removed) {
  int tid = get_global_id(0);

  if (tid >= num_training_patterns) {
    return;
  }

  int i;

  float tid_dim_val = training_patterns[hook(0, dim_removed * num_training_patterns + tid)];

  for (i = 0; i < num_training_patterns; i++) {
    dim_removed_matrix[hook(1, i * num_training_patterns + tid)] = (training_patterns[hook(0, dim_removed * num_training_patterns + i)] - tid_dim_val);
  }
}