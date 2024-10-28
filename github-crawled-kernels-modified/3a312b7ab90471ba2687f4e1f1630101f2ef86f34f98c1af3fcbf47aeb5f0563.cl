//{"hm":4,"initial_mat":0,"kernel_mat":1,"n":3,"resulting_mat":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution_2d(global float* initial_mat, global float* kernel_mat, global float* resulting_mat, int n, int hm) {
  int row = get_global_id(0);
  int col = get_global_id(1);

  if (row >= n || col >= n)
    return;

  float sum = 0;

  for (int k = -hm; k <= hm; ++k) {
    for (int l = -hm; l <= hm; ++l) {
      int idx_init = (row + k) * n + col + l;
      int idx_kernel = (k + hm) * (hm * 2 + 1) + l + hm;
      if (row + k >= 0 && row + k < n && col + l >= 0 && col + l < n)
        sum += initial_mat[hook(0, idx_init)] * kernel_mat[hook(1, idx_kernel)];
    }
  }

  resulting_mat[hook(2, row * n + col)] = sum;
}