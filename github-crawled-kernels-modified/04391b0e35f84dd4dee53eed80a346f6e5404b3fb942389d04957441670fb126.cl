//{"N":0,"T":1,"gamma":3,"gamma_state_sum":4,"sm":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_gamma_state_sum(const int N, const int T, local float* sm, global const float* gamma, global float* gamma_state_sum) {
  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  size_t lx = get_local_id(0);
  size_t ly = get_local_id(1);

  float data = 0.f;

  int i;
  for (i = gy; i < T; i += 16) {
    data += gamma[hook(3, i * N + gx)];
  }

  sm[hook(2, lx * 17 + ly)] = data;

  barrier(0x01);

  if (gy == 0) {
    int start = lx * 17;
    data = sm[hook(2, start)] + sm[hook(2, start + 1)] + sm[hook(2, start + 2)] + sm[hook(2, start + 3)] + sm[hook(2, start + 4)] + sm[hook(2, start + 5)] + sm[hook(2, start + 6)] + sm[hook(2, start + 7)] + sm[hook(2, start + 8)] + sm[hook(2, start + 9)] + sm[hook(2, start + 10)] + sm[hook(2, start + 11)] + sm[hook(2, start + 12)] + sm[hook(2, start + 13)] + sm[hook(2, start + 14)] + sm[hook(2, start + 15)];

    if (data == 0.f)
      data = 1.f;

    gamma_state_sum[hook(4, gx)] = data;
  }
}