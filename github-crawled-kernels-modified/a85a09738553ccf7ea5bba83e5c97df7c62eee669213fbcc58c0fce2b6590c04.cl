//{"QR":0,"V":1,"size1":2,"size2":3,"strideQ":4,"sums":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void col_reduce_lcl_array(local float* sums, unsigned int lcl_id, unsigned int lcl_sz);
kernel void house_update_QR(global float* QR, global float* V, unsigned int size1, unsigned int size2, unsigned int strideQ, local float* sums) {
  unsigned int glb_id = get_global_id(0);

  unsigned int grp_id = get_group_id(0);
  unsigned int grp_nm = get_num_groups(0);

  unsigned int lcl_id = get_local_id(0);
  unsigned int lcl_sz = get_local_size(0);

  float ss = 0;

  for (unsigned int i = grp_id; i < size2; i += grp_nm) {
    ss = 0;
    for (unsigned int j = lcl_id; j < size2; j += lcl_sz)
      ss = ss + (V[hook(1, j)] * QR[hook(0, i * strideQ + j)]);
    sums[hook(5, lcl_id)] = ss;

    barrier(0x01);
    col_reduce_lcl_array(sums, lcl_id, lcl_sz);
    barrier(0x01);

    float sum_Qv = sums[hook(5, 0)];
    for (unsigned int j = lcl_id; j < size2; j += lcl_sz)
      QR[hook(0, i * strideQ + j)] = QR[hook(0, i * strideQ + j)] - (2 * V[hook(1, j)] * sum_Qv);
  }
}