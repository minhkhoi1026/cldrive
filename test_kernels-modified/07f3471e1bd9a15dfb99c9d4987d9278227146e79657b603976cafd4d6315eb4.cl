//{"A":0,"A_inc1":3,"A_inc2":4,"A_internal_size1":7,"A_internal_size2":8,"A_size1":5,"A_size2":6,"A_start1":1,"A_start2":2,"fac2":9,"float2":15,"inc1":13,"inc2":17,"options2":10,"size1":14,"size2":18,"start1":12,"start2":16,"vec1":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scaled_rank1_update_gpu(global float* A, unsigned int A_start1, unsigned int A_start2, unsigned int A_inc1, unsigned int A_inc2, unsigned int A_size1, unsigned int A_size2, unsigned int A_internal_size1, unsigned int A_internal_size2, global const float* fac2, unsigned int options2, global const float* vec1, unsigned int start1, unsigned int inc1, unsigned int size1, global const float* float2, unsigned int start2, unsigned int inc2, unsigned int size2) {
  float alpha = fac2[hook(9, 0)];
  if ((options2 >> 2) > 1) {
    for (unsigned int i = 1; i < (options2 >> 2); ++i)
      alpha += fac2[hook(9, i)];
  }
  if (options2 & (1 << 0))
    alpha = -alpha;
  if (options2 & (1 << 1))
    alpha = ((float)(1)) / alpha;

  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);

  for (unsigned int row = row_gid; row < A_size1; row += get_num_groups(0)) {
    float tmp = alpha * vec1[hook(11, row * inc1 + start1)];
    for (unsigned int col = col_gid; col < A_size2; col += get_local_size(0))
      A[hook(0, (row * A_inc1 + A_start1) * A_internal_size2 + col * A_inc2 + A_start2)] += tmp * float2[hook(15, col * inc2 + start2)];
  }
}