//{"G":21,"G_inc1":24,"G_inc2":25,"G_internal_size1":26,"G_internal_size2":27,"G_start1":22,"G_start2":23,"M":12,"M_inc1":15,"M_inc2":16,"M_internal_size1":19,"M_internal_size2":20,"M_size1":17,"M_size2":18,"M_start1":13,"M_start2":14,"W":3,"W_inc1":6,"W_inc2":7,"W_internal_size1":10,"W_internal_size2":11,"W_size1":8,"W_size2":9,"W_start1":4,"W_start2":5,"learningRate":0,"momentum":2,"weightDecayFac":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_gradient_descent_with_momentum(float learningRate, float weightDecayFac, float momentum, global float* W, unsigned int W_start1, unsigned int W_start2, unsigned int W_inc1, unsigned int W_inc2, unsigned int W_size1, unsigned int W_size2, unsigned int W_internal_size1, unsigned int W_internal_size2, global float* M, unsigned int M_start1, unsigned int M_start2, unsigned int M_inc1, unsigned int M_inc2, unsigned int M_size1, unsigned int M_size2, unsigned int M_internal_size1, unsigned int M_internal_size2, const global float* G, unsigned int G_start1, unsigned int G_start2, unsigned int G_inc1, unsigned int G_inc2, unsigned int G_internal_size1, unsigned int G_internal_size2) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < W_size1; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < W_size2; col += get_local_size(0)) {
      M[hook(12, (row * W_inc1 + W_start1) * W_internal_size2 + (col * W_inc2 + W_start2))] = -learningRate * G[hook(21, (row * G_inc1 + G_start1) * G_internal_size2 + (col * G_inc2 + G_start2))] - weightDecayFac * W[hook(3, (row * W_inc1 + W_start1) * W_internal_size2 + (col * W_inc2 + W_start2))] + momentum * M[hook(12, (row * M_inc1 + M_start1) * M_internal_size2 + (col * M_inc2 + M_start2))];
      W[hook(3, (row * W_inc1 + W_start1) * W_internal_size2 + (col * W_inc2 + W_start2))] += M[hook(12, (row * W_inc1 + W_start1) * W_internal_size2 + (col * W_inc2 + W_start2))];
    }
  }
}