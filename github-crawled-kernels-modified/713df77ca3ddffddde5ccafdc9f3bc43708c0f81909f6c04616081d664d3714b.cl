//{"A":0,"V":1,"col_start":3,"row_start":2,"size1":4,"size2":5,"stride":6,"sums":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void col_reduce_lcl_array(local float* sums, unsigned int lcl_id, unsigned int lcl_sz);
kernel void house_update_A_left(global float* A, constant float* V, unsigned int row_start, unsigned int col_start, unsigned int size1, unsigned int size2, unsigned int stride, local float* sums) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  unsigned int grp_id = get_group_id(0);
  unsigned int grp_nm = get_num_groups(0);

  unsigned int lcl_id = get_local_id(0);
  unsigned int lcl_sz = get_local_size(0);

  float ss = 0;

  for (unsigned int i = glb_id + col_start; i < size2; i += glb_sz) {
    ss = 0;
    for (unsigned int j = row_start; j < size1; j++)
      ss = ss + (V[hook(1, j)] * A[hook(0, j * stride + i)]);

    for (unsigned int j = row_start; j < size1; j++)
      A[hook(0, j * stride + i)] = A[hook(0, j * stride + i)] - (2 * V[hook(1, j)] * ss);
  }
}