//{"N":2,"expt_A_d":1,"lds":3,"xi_sum_d":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_expect_A(global const float* xi_sum_d, global float* expt_A_d, const int N) {
  unsigned int gx = get_global_id(0);
  unsigned int lx = get_local_id(0);

  unsigned int gy = get_global_id(1);
  unsigned int ly = get_local_id(1);

  local float lds[256];

  size_t m = get_num_groups(0);

  int i, col;
  float data;
  size_t offset = gy * N;

  data = xi_sum_d[hook(0, offset + gx)];

  for (i = 1; i < m; ++i) {
    col = gx + i * 16;
    data += xi_sum_d[hook(0, offset + col)];
  }

  lds[hook(3, ly * 16 + lx)] = data;

  barrier(0x01);

  if (gx == 0) {
    int start = ly * 16;
    data = lds[hook(3, start)] + lds[hook(3, start + 1)] + lds[hook(3, start + 2)] + lds[hook(3, start + 3)] + lds[hook(3, start + 4)] + lds[hook(3, start + 5)] + lds[hook(3, start + 6)] + lds[hook(3, start + 7)] + lds[hook(3, start + 8)] + lds[hook(3, start + 9)] + lds[hook(3, start + 10)] + lds[hook(3, start + 11)] + lds[hook(3, start + 12)] + lds[hook(3, start + 13)] + lds[hook(3, start + 14)] + lds[hook(3, start + 15)];
    if (data == 0.f)
      data = 1.f;
    lds[hook(3, start)] = data;
  }

  barrier(0x01);

  for (i = 0; i < m; ++i) {
    col = gx + i * 16;
    expt_A_d[hook(1, offset + col)] = xi_sum_d[hook(0, offset + col)] / lds[hook(3, ly * 16)];
  }
}