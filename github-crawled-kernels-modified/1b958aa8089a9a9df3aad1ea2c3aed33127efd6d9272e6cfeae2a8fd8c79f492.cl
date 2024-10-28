//{"T":4,"current":5,"expect_mu":1,"gamma_obs":0,"gamma_state_sumC":2,"hs":3,"lds":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_expectmu(global const float* gamma_obs, global float* expect_mu, constant float* gamma_state_sumC, const int hs, const int T, const int current) {
  local float lds[272];

  unsigned int gx = get_global_id(0);
  unsigned int gy = get_global_id(1);
  unsigned int lx = get_local_id(0);
  unsigned int ly = get_local_id(1);

  int m = T / 16;

  int i, col;
  float data;

  unsigned int offset = gy * T;

  data = gamma_obs[hook(0, offset + gx)];

  for (i = 1; i < m; ++i) {
    col = i * 16 + gx;
    data += gamma_obs[hook(0, offset + col)];
  }

  lds[hook(6, ly * (16 + 1) + lx)] = data;

  barrier(0x01);

  if (gx == 0) {
    int start = ly * (16 + 1);
    data = lds[hook(6, start)] + lds[hook(6, start + 1)] + lds[hook(6, start + 2)] + lds[hook(6, start + 3)] + lds[hook(6, start + 4)] + lds[hook(6, start + 5)] + lds[hook(6, start + 6)] + lds[hook(6, start + 7)] + lds[hook(6, start + 8)] + lds[hook(6, start + 9)] + lds[hook(6, start + 10)] + lds[hook(6, start + 11)] + lds[hook(6, start + 12)] + lds[hook(6, start + 13)] + lds[hook(6, start + 14)] + lds[hook(6, start + 15)];
    expect_mu[hook(1, current + gy)] = data / gamma_state_sumC[hook(2, hs)];
  }
}