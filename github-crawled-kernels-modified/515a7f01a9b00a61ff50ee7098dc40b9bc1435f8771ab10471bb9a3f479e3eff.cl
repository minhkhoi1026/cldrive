//{"N":0,"expect_A":3,"sm":1,"xi_sum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_expectA(const int N, local float* sm, global const float* xi_sum, global float* expect_A) {
  size_t gx = get_global_id(0);
  size_t lx = get_local_id(0);

  size_t gy = get_global_id(1);
  size_t ly = get_local_id(1);

  float data = 0.f;

  int start = ly * 17;
  size_t offset = gy * N;

  int i;
  for (i = gx; i < N; i += 16) {
    data += xi_sum[hook(2, offset + i)];
  }

  sm[hook(1, start + lx)] = data;

  barrier(0x01);

  if (gx == 0) {
    data = sm[hook(1, start)] + sm[hook(1, start + 1)] + sm[hook(1, start + 2)] + sm[hook(1, start + 3)] + sm[hook(1, start + 4)] + sm[hook(1, start + 5)] + sm[hook(1, start + 6)] + sm[hook(1, start + 7)] + sm[hook(1, start + 8)] + sm[hook(1, start + 9)] + sm[hook(1, start + 10)] + sm[hook(1, start + 11)] + sm[hook(1, start + 12)] + sm[hook(1, start + 13)] + sm[hook(1, start + 14)] + sm[hook(1, start + 15)];

    if (data == 0.f)
      data = 1.f;

    sm[hook(1, start)] = data;
  }

  barrier(0x01);

  for (i = gx; i < N; i += 16) {
    expect_A[hook(3, offset + i)] = xi_sum[hook(2, offset + i)] / sm[hook(1, start)];
  }
}