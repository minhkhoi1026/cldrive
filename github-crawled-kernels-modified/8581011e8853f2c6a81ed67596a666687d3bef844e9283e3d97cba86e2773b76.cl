//{"D":6,"T":7,"expect_mu_state":4,"expect_sigma_sym":2,"gamma_obs":0,"gamma_state_sumC":3,"hs":5,"lds_a":8,"lds_b":9,"observations":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_expectsigma_dev(global const float* gamma_obs, global const float* observations, global float* expect_sigma_sym, constant float* gamma_state_sumC, constant float* expect_mu_state, const int hs, const int D, const int T) {
  local float lds_a[72];
  local float lds_b[72];

  unsigned int lx = get_local_id(0);
  unsigned int ly = get_local_id(1);

  int bx = get_group_id(0);
  int by = get_group_id(1);

  int nx = T / 8;
  int Col = bx * 8 + lx;
  int Row = by * 8 + ly;

  float sum = 0.f;
  int m;

  for (m = 0; m < nx; ++m) {
    lds_a[hook(8, ly * 9 + lx)] = gamma_obs[hook(0, Row * T + m * 8 + lx)];
    lds_b[hook(9, ly * 9 + lx)] = observations[hook(1, (m * 8 + ly) * D + Col)];

    barrier(0x01);

    int kk;
    for (kk = 0; kk < 8; ++kk) {
      sum += lds_a[hook(8, ly * 9 + kk)] * lds_b[hook(9, kk * 9 + lx)];
    }

    barrier(0x01);
  }

  expect_sigma_sym[hook(2, Row * D + Col)] = sum / gamma_state_sumC[hook(3, hs)] - expect_mu_state[hook(4, Row)] * expect_mu_state[hook(4, Col)];
}