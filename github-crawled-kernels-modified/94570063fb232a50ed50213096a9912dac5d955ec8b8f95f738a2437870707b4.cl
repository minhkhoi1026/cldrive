//{"D":0,"T":1,"expect_mu":7,"gamma_obs":5,"gamma_state_sum":6,"hs":3,"offset":2,"sm":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_expect_mu(const int D, const int T, const int offset, const int hs, local float* sm, global const float* gamma_obs, global const float* gamma_state_sum, global float* expect_mu) {
  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  size_t lx = get_local_id(0);
  size_t ly = get_local_id(1);

  size_t stride = gy * T;

  float data = 0.f;

  int i;
  for (i = gx; i < T; i += 16) {
    data += gamma_obs[hook(5, stride + i)];
  }

  sm[hook(4, ly * 17 + lx)] = data;

  barrier(0x01);

  if (gx == 0) {
    int start = ly * 17;
    data = sm[hook(4, start)] + sm[hook(4, start + 1)] + sm[hook(4, start + 2)] + sm[hook(4, start + 3)] + sm[hook(4, start + 4)] + sm[hook(4, start + 5)] + sm[hook(4, start + 6)] + sm[hook(4, start + 7)] + sm[hook(4, start + 8)] + sm[hook(4, start + 9)] + sm[hook(4, start + 10)] + sm[hook(4, start + 11)] + sm[hook(4, start + 12)] + sm[hook(4, start + 13)] + sm[hook(4, start + 14)] + sm[hook(4, start + 15)];

    if (gy < D)
      expect_mu[hook(7, offset + gy)] = data / gamma_state_sum[hook(6, hs)];
  }
}