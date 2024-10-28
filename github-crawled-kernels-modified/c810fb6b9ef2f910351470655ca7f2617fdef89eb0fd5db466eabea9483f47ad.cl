//{"A":3,"B":4,"C":5,"K":2,"M":0,"N":1,"a_r":6,"b_r":7,"c_r":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(const int M, const int N, const int K, read_only image2d_t A, read_only image2d_t B, write_only image2d_t C) {
  const sampler_t smp = 0 | 4 | 0x10;

  float4 c_r[4] = {0, 0, 0, 0};
  float4 a_r[4], b_r[4];

  int const a_off_thr = get_global_id(0);
  int const b_off_thr = get_global_id(1);

  int2 a_samp = {0, a_off_thr};
  int2 b_samp = {0, b_off_thr};

  for (short k = 0; k < K / 4; k++) {
    for (short i = 0; i < 4; ++i) {
      a_r[hook(6, i)] = read_imagef(A, smp, a_samp);
      b_r[hook(7, i)] = read_imagef(B, smp, b_samp);
      ++a_samp.x;
      ++b_samp.x;
    }

    for (short i = 0; i < 4; ++i) {
      float4 ov = c_r[hook(8, i)];

      ov.x += a_r[hook(6, i)].x * b_r[hook(7, 0)].x;
      ov.x += a_r[hook(6, i)].y * b_r[hook(7, 0)].y;
      ov.x += a_r[hook(6, i)].z * b_r[hook(7, 0)].z;
      ov.x += a_r[hook(6, i)].w * b_r[hook(7, 0)].w;

      ov.y += a_r[hook(6, i)].x * b_r[hook(7, 1)].x;
      ov.y += a_r[hook(6, i)].y * b_r[hook(7, 1)].y;
      ov.y += a_r[hook(6, i)].z * b_r[hook(7, 1)].z;
      ov.y += a_r[hook(6, i)].w * b_r[hook(7, 1)].w;

      ov.z += a_r[hook(6, i)].x * b_r[hook(7, 2)].x;
      ov.z += a_r[hook(6, i)].y * b_r[hook(7, 2)].y;
      ov.z += a_r[hook(6, i)].z * b_r[hook(7, 2)].z;
      ov.z += a_r[hook(6, i)].w * b_r[hook(7, 2)].w;

      ov.w += a_r[hook(6, i)].x * b_r[hook(7, 3)].x;
      ov.w += a_r[hook(6, i)].y * b_r[hook(7, 3)].y;
      ov.w += a_r[hook(6, i)].z * b_r[hook(7, 3)].z;
      ov.w += a_r[hook(6, i)].w * b_r[hook(7, 3)].w;

      c_r[hook(8, i)] = ov;
    }
  }

  int2 c_samp = {a_off_thr, b_off_thr * 4};
  for (short i = 0; i < 4; i++) {
    write_imagef(C, c_samp, c_r[hook(8, i)]);
    ++c_samp.y;
  }
}