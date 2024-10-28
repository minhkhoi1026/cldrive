//{"cs":1,"cs_lcl":7,"end_i":6,"matr":0,"size":3,"ss":2,"ss_lcl":8,"start_i":5,"stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void givens_next(global float* matr, global float* cs, global float* ss, unsigned int size, unsigned int stride, unsigned int start_i, unsigned int end_i) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  unsigned int lcl_id = get_local_id(0);
  unsigned int lcl_sz = get_local_size(0);

  unsigned int j = glb_id;

  local float cs_lcl[256];
  local float ss_lcl[256];

  float x = (j < size) ? matr[hook(0, (end_i + 1) * stride + j)] : 0;

  unsigned int elems_num = end_i - start_i + 1;
  unsigned int block_num = (elems_num + lcl_sz - 1) / lcl_sz;

  for (unsigned int block_id = 0; block_id < block_num; block_id++) {
    unsigned int to = min(elems_num - block_id * lcl_sz, lcl_sz);

    if (lcl_id < to) {
      cs_lcl[hook(7, lcl_id)] = cs[hook(1, end_i - (lcl_id + block_id * lcl_sz))];
      ss_lcl[hook(8, lcl_id)] = ss[hook(2, end_i - (lcl_id + block_id * lcl_sz))];
      ;
    }

    barrier(0x01);

    if (j < size) {
      for (unsigned int ind = 0; ind < to; ind++) {
        unsigned int i = end_i - (ind + block_id * lcl_sz);

        float z = matr[hook(0, i * stride + j)];

        float cs_val = cs_lcl[hook(7, ind)];
        float ss_val = ss_lcl[hook(8, ind)];

        matr[hook(0, (i + 1) * stride + j)] = x * cs_val + z * ss_val;
        x = -x * ss_val + z * cs_val;
      }
    }
    barrier(0x01);
  }
  if (j < size)
    matr[hook(0, (start_i) * stride + j)] = x;
}