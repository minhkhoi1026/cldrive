//{"A":0,"Bi":7,"C":2,"a":10,"b":9,"c":8,"k":6,"lda":1,"ldc":3,"m":4,"n":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sgemm_buf_img(global const float* A, const int lda, global float* C, const int ldc, const int m, const int n, const int k, read_only image2d_t Bi) {
  int gx = get_global_id(0) << 2;
  int gy = get_global_id(1) << 3;

  if ((gx < n) && (gy < m)) {
    float4 a[8];
    float4 b[4];
    float4 c[8];

    for (int i = 0; i < 8; i++) {
      c[hook(8, i)] = 0.0f;
    }
    A += gy * lda;

    for (int pos = 0; pos < k; pos += 4) {
      for (int i = 0; i < 4; i++) {
        b[hook(9, i)] = read_imagef(Bi, (int2)(gx >> 2, pos + i));
      }

      for (int i = 0; i < 8; i++) {
        a[hook(10, i)] = vload4(0, A + mul24(i, lda) + pos);
        c[hook(8, i)] += a[hook(10, i)].x * b[hook(9, 0)] + a[hook(10, i)].y * b[hook(9, 1)] + a[hook(10, i)].z * b[hook(9, 2)] + a[hook(10, i)].w * b[hook(9, 3)];
      }
    }

    for (int i = 0; i < 8; i++) {
      int C_offs = mul24((gy + i), ldc) + gx;
      vstore4(c[hook(8, i)], 0, C + C_offs);
    }
  }
}