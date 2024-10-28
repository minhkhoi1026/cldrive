//{"D":0,"T":1,"constMem":3,"gamma_obs":4,"gamma_state_sum":6,"hs":2,"lds_a":8,"lds_b":9,"observations":5,"sigma_dev":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_sigma_dev(const int D, const int T, const int hs, constant float* constMem, global const float* gamma_obs, global const float* observations, global const float* gamma_state_sum, global float* sigma_dev) {
  local float lds_a[72];
  local float lds_b[72];

  int lx = get_local_id(0);
  int ly = get_local_id(1);

  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  float sum = 0.f;

  int iter = T / 8;
  int m;
  for (m = 0; m < iter; ++m) {
    lds_a[hook(8, ly * 9 + lx)] = gamma_obs[hook(4, gy * T + (lx + m * 8))];
    lds_b[hook(9, ly * 9 + lx)] = observations[hook(5, gx * T + (ly + m * 8))];

    barrier(0x01);

    int kk;
    for (kk = 0; kk < 8; ++kk) {
      sum += lds_a[hook(8, ly * 9 + kk)] * lds_b[hook(9, lx * 9 + kk)];
    }

    barrier(0x01);
  }

  sigma_dev[hook(7, gy * D + gx)] = sum / gamma_state_sum[hook(6, hs)] - constMem[hook(3, gy)] * constMem[hook(3, gx)];
}