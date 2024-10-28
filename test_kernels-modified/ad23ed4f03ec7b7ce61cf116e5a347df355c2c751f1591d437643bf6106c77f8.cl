//{"A":0,"V":1,"col_start":3,"row_start":2,"size1":4,"size2":5,"stride":6,"sums":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void col_reduce_lcl_array(local float* sums, unsigned int lcl_id, unsigned int lcl_sz);
kernel void house_update_A_right(global float* A, global float* V, unsigned int row_start, unsigned int col_start, unsigned int size1, unsigned int size2, unsigned int stride, local float* sums) {
  unsigned int glb_id = get_global_id(0);

  unsigned int grp_id = get_group_id(0);
  unsigned int grp_nm = get_num_groups(0);

  unsigned int lcl_id = get_local_id(0);
  unsigned int lcl_sz = get_local_size(0);

  float ss = 0;

  for (unsigned int i = grp_id + row_start; i < size1; i += grp_nm) {
    ss = 0;

    for (unsigned int j = lcl_id; j < size2; j += lcl_sz)
      ss = ss + (V[hook(1, j)] * A[hook(0, i * stride + j)]);
    sums[hook(7, lcl_id)] = ss;

    barrier(0x01);
    col_reduce_lcl_array(sums, lcl_id, lcl_sz);
    barrier(0x01);

    float sum_Av = sums[hook(7, 0)];

    for (unsigned int j = lcl_id; j < size2; j += lcl_sz)
      A[hook(0, i * stride + j)] = A[hook(0, i * stride + j)] - (2 * V[hook(1, j)] * sum_Av);
  }
}