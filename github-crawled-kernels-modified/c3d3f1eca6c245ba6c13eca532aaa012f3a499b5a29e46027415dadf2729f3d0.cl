//{"N":0,"a":4,"beta":5,"constMem":3,"current":1,"sm":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BK_update_beta(const int N, const int current, local float* sm, constant float* constMem, global float* a, global float* beta) {
  size_t lx = get_local_id(0);
  size_t gx = get_global_id(0);

  size_t ly = get_local_id(1);
  size_t gy = get_global_id(1);

  int iters = N / 16;

  float data = 0.f;

  int i;
  for (i = 0; i < iters; ++i) {
    int col = i * 16 + lx;
    data += a[hook(4, gy * N + col)] * constMem[hook(3, col)];
  }

  sm[hook(2, ly * 17 + lx)] = data;

  barrier(0x01);

  if (gx == 0) {
    int start = ly * 17;

    data = sm[hook(2, start)] + sm[hook(2, start + 1)] + sm[hook(2, start + 2)] + sm[hook(2, start + 3)] + sm[hook(2, start + 4)] + sm[hook(2, start + 5)] + sm[hook(2, start + 6)] + sm[hook(2, start + 7)] + sm[hook(2, start + 8)] + sm[hook(2, start + 9)] + sm[hook(2, start + 10)] + sm[hook(2, start + 11)] + sm[hook(2, start + 12)] + sm[hook(2, start + 13)] + sm[hook(2, start + 14)] + sm[hook(2, start + 15)];

    beta[hook(5, current + gy)] = data;
  }
}