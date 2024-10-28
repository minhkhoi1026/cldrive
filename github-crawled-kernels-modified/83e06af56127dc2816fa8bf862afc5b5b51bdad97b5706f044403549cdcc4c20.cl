//{"A":0,"A_inc1":3,"A_inc2":4,"A_internal_size1":7,"A_internal_size2":8,"A_size1":5,"A_size2":6,"A_start1":1,"A_start2":2,"B":11,"B_inc1":14,"B_inc2":15,"B_internal_size1":16,"B_internal_size2":17,"B_start1":12,"B_start2":13,"C":20,"C_inc1":23,"C_inc2":24,"C_internal_size1":25,"C_internal_size2":26,"C_start1":21,"C_start2":22,"fac2":9,"fac3":18,"options2":10,"options3":19}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ambm_gpu_cpu(global float* A, unsigned int A_start1, unsigned int A_start2, unsigned int A_inc1, unsigned int A_inc2, unsigned int A_size1, unsigned int A_size2, unsigned int A_internal_size1, unsigned int A_internal_size2, global const float* fac2, unsigned int options2, global const float* B, unsigned int B_start1, unsigned int B_start2, unsigned int B_inc1, unsigned int B_inc2, unsigned int B_internal_size1, unsigned int B_internal_size2, float fac3, unsigned int options3, global const float* C, unsigned int C_start1, unsigned int C_start2, unsigned int C_inc1, unsigned int C_inc2, unsigned int C_internal_size1, unsigned int C_internal_size2) {
  float alpha = fac2[hook(9, 0)];
  if ((options2 >> 2) > 1) {
    for (unsigned int i = 1; i < (options2 >> 2); ++i)
      alpha += fac2[hook(9, i)];
  }
  if (options2 & (1 << 0))
    alpha = -alpha;
  if (options2 & (1 << 1))
    alpha = ((float)(1)) / alpha;

  float beta = fac3;
  if (options3 & (1 << 0))
    beta = -beta;
  if (options3 & (1 << 1))
    beta = ((float)(1)) / beta;

  unsigned int row_gid = get_global_id(0) % get_local_size(0);
  unsigned int col_gid = get_global_id(0) / get_local_size(0);

  for (unsigned int col = col_gid; col < A_size2; col += get_num_groups(0))
    for (unsigned int row = row_gid; row < A_size1; row += get_local_size(0))
      A[hook(0, (row * A_inc1 + A_start1) + (col * A_inc2 + A_start2) * A_internal_size1)] = B[hook(11, (row * B_inc1 + B_start1) + (col * B_inc2 + B_start2) * B_internal_size1)] * alpha + C[hook(20, (row * C_inc1 + C_start1) + (col * C_inc2 + C_start2) * C_internal_size1)] * beta;
}