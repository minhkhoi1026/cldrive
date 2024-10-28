//{"M":10,"coeffs":12,"dst":1,"dstStep":7,"dst_cols":4,"dst_offset":9,"dst_rows":5,"src":0,"srcStep":6,"src_cols":2,"src_offset":8,"src_rows":3,"tab":15,"tabx":14,"taby":13,"threadCols":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float F;
typedef float4 F4;
inline void interpolateCubic(float x, float* coeffs) {
  const float A = -0.75f;

  coeffs[hook(12, 0)] = ((A * (x + 1.f) - 5.0f * A) * (x + 1.f) + 8.0f * A) * (x + 1.f) - 4.0f * A;
  coeffs[hook(12, 1)] = ((A + 2.f) * x - (A + 3.f)) * x * x + 1.f;
  coeffs[hook(12, 2)] = ((A + 2.f) * (1.f - x) - (A + 3.f)) * (1.f - x) * (1.f - x) + 1.f;
  coeffs[hook(12, 3)] = 1.f - coeffs[hook(12, 0)] - coeffs[hook(12, 1)] - coeffs[hook(12, 2)];
}

kernel void warpAffineLinear_C1_D5(global float* src, global float* dst, int src_cols, int src_rows, int dst_cols, int dst_rows, int srcStep, int dstStep, int src_offset, int dst_offset, constant F* M, int threadCols) {
  int dx = get_global_id(0);
  int dy = get_global_id(1);

  if (dx < threadCols && dy < dst_rows) {
    int round_delta = (1 << max(10, (int)5)) / (1 << 5) / 2;

    src_offset = (src_offset >> 2);

    int X0 = rint(M[hook(10, 0)] * dx * (1 << max(10, (int)5)));
    int Y0 = rint(M[hook(10, 3)] * dx * (1 << max(10, (int)5)));
    X0 += rint((M[hook(10, 1)] * dy + M[hook(10, 2)]) * (1 << max(10, (int)5))) + round_delta;
    Y0 += rint((M[hook(10, 4)] * dy + M[hook(10, 5)]) * (1 << max(10, (int)5))) + round_delta;
    X0 = X0 >> (max(10, (int)5) - 5);
    Y0 = Y0 >> (max(10, (int)5) - 5);

    short sx0 = (short)(X0 >> 5);
    short sy0 = (short)(Y0 >> 5);
    short ax0 = (short)(X0 & ((1 << 5) - 1));
    short ay0 = (short)(Y0 & ((1 << 5) - 1));

    float v0, v1, v2, v3;

    v0 = (sx0 >= 0 && sx0 < src_cols && sy0 >= 0 && sy0 < src_rows) ? src[hook(0, src_offset + sy0 * srcStep + sx0)] : 0;
    v1 = (sx0 + 1 >= 0 && sx0 + 1 < src_cols && sy0 >= 0 && sy0 < src_rows) ? src[hook(0, src_offset + sy0 * srcStep + sx0 + 1)] : 0;
    v2 = (sx0 >= 0 && sx0 < src_cols && sy0 + 1 >= 0 && sy0 + 1 < src_rows) ? src[hook(0, src_offset + (sy0 + 1) * srcStep + sx0)] : 0;
    v3 = (sx0 + 1 >= 0 && sx0 + 1 < src_cols && sy0 + 1 >= 0 && sy0 + 1 < src_rows) ? src[hook(0, src_offset + (sy0 + 1) * srcStep + sx0 + 1)] : 0;

    float tab[4];
    float taby[2], tabx[2];
    taby[hook(13, 0)] = 1.0f - 1.f / (1 << 5) * ay0;
    taby[hook(13, 1)] = 1.f / (1 << 5) * ay0;
    tabx[hook(14, 0)] = 1.0f - 1.f / (1 << 5) * ax0;
    tabx[hook(14, 1)] = 1.f / (1 << 5) * ax0;

    tab[hook(15, 0)] = taby[hook(13, 0)] * tabx[hook(14, 0)];
    tab[hook(15, 1)] = taby[hook(13, 0)] * tabx[hook(14, 1)];
    tab[hook(15, 2)] = taby[hook(13, 1)] * tabx[hook(14, 0)];
    tab[hook(15, 3)] = taby[hook(13, 1)] * tabx[hook(14, 1)];

    float sum = 0;
    sum += v0 * tab[hook(15, 0)] + v1 * tab[hook(15, 1)] + v2 * tab[hook(15, 2)] + v3 * tab[hook(15, 3)];
    if (dx >= 0 && dx < dst_cols && dy >= 0 && dy < dst_rows)
      dst[hook(1, (dst_offset >> 2) + dy * dstStep + dx)] = sum;
  }
}