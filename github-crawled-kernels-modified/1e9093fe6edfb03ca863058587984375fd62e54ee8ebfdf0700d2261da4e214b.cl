//{"in":1,"out":0,"tmp0":2,"tmp1":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void msquare(global float* out, global float* in, local float* tmp0, local float* tmp1) {
  size_t size = get_global_size(0), block_size = get_local_size(0);

  unsigned int ii = get_global_id(0), jj = get_global_id(1);

  unsigned int i = get_local_id(0), j = get_local_id(1);

  float val = 0.0f;

  for (unsigned int kk = 0; kk < size; kk += block_size) {
    tmp0[hook(2, (i) * block_size + (j))] = in[hook(1, (ii) * size + (kk + j))];
    tmp1[hook(3, (i) * block_size + (j))] = in[hook(1, (kk + i) * size + (jj))];

    barrier(0x01);

    for (unsigned int k = 0; k < block_size; ++k)
      val += tmp0[hook(2, (i) * block_size + (k))] * tmp1[hook(3, (k) * block_size + (j))];

    barrier(0x01);
  }

  out[hook(0, (ii) * size + (jj))] = val;
}