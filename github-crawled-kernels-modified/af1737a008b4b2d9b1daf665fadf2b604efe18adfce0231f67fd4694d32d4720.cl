//{"G":11,"G_inc1":14,"G_inc2":15,"G_internal_size1":16,"G_internal_size2":17,"G_start1":12,"G_start2":13,"W":2,"W_inc1":5,"W_inc2":6,"W_internal_size1":9,"W_internal_size2":10,"W_size1":7,"W_size2":8,"W_start1":3,"W_start2":4,"learningRate":0,"weightDecayFac":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_gradient_descent(float learningRate, float weightDecayFac, global float* W, unsigned int W_start1, unsigned int W_start2, unsigned int W_inc1, unsigned int W_inc2, unsigned int W_size1, unsigned int W_size2, unsigned int W_internal_size1, unsigned int W_internal_size2, const global float* G, unsigned int G_start1, unsigned int G_start2, unsigned int G_inc1, unsigned int G_inc2, unsigned int G_internal_size1, unsigned int G_internal_size2) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < W_size1; row += get_num_groups(0))
    for (unsigned int col = col_gid; col < W_size2; col += get_local_size(0))
      W[hook(2, (row * W_inc1 + W_start1) * W_internal_size2 + (col * W_inc2 + W_start2))] -= learningRate * G[hook(11, (row * G_inc1 + G_start1) * G_internal_size2 + (col * G_inc2 + G_start2))] + weightDecayFac * W[hook(2, (row * W_inc1 + W_start1) * W_internal_size2 + (col * W_inc2 + W_start2))];
}