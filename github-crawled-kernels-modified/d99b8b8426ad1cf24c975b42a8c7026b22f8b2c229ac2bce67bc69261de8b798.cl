//{"M":10,"coeffs":12,"dst":1,"dstStep":7,"dst_cols":4,"dst_offset":9,"dst_rows":5,"src":0,"srcStep":6,"src_cols":2,"src_offset":8,"src_rows":3,"tab":14,"tab1x":16,"tab1y":15,"threadCols":11,"v":13}
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

kernel void warpAffineCubic_C4_D5(global float4* src, global float4* dst, int src_cols, int src_rows, int dst_cols, int dst_rows, int srcStep, int dstStep, int src_offset, int dst_offset, constant F* M, int threadCols) {
  int dx = get_global_id(0);
  int dy = get_global_id(1);

  if (dx < threadCols && dy < dst_rows) {
    int round_delta = (1 << max(10, (int)5)) / (1 << 5) / 2;

    src_offset = (src_offset >> 4);
    dst_offset = (dst_offset >> 4);
    srcStep = (srcStep >> 2);
    dstStep = (dstStep >> 2);

    int X0 = rint(M[hook(10, 0)] * dx * (1 << max(10, (int)5)));
    int Y0 = rint(M[hook(10, 3)] * dx * (1 << max(10, (int)5)));
    X0 += rint((M[hook(10, 1)] * dy + M[hook(10, 2)]) * (1 << max(10, (int)5))) + round_delta;
    Y0 += rint((M[hook(10, 4)] * dy + M[hook(10, 5)]) * (1 << max(10, (int)5))) + round_delta;
    X0 = X0 >> (max(10, (int)5) - 5);
    Y0 = Y0 >> (max(10, (int)5) - 5);

    short sx = (short)(X0 >> 5) - 1;
    short sy = (short)(Y0 >> 5) - 1;
    short ay = (short)(Y0 & ((1 << 5) - 1));
    short ax = (short)(X0 & ((1 << 5) - 1));

    float4 v[16];
    int i;

    for (i = 0; i < 16; i++)
      v[hook(13, i)] = (sx + (i & 3) >= 0 && sx + (i & 3) < src_cols && sy + (i >> 2) >= 0 && sy + (i >> 2) < src_rows) ? src[hook(0, src_offset + (sy + (i >> 2)) * srcStep + (sx + (i & 3)))] : (float4)0;

    float tab[16];
    float tab1y[4], tab1x[4];
    float axx, ayy;

    ayy = 1.f / (1 << 5) * ay;
    axx = 1.f / (1 << 5) * ax;
    interpolateCubic(ayy, tab1y);
    interpolateCubic(axx, tab1x);

    for (i = 0; i < 16; i++) {
      tab[hook(14, i)] = tab1y[hook(15, (i >> 2))] * tab1x[hook(16, (i & 3))];
    }

    if (dx >= 0 && dx < dst_cols && dy >= 0 && dy < dst_rows) {
      float4 sum = 0;
      for (i = 0; i < 16; i++) {
        sum += v[hook(13, i)] * tab[hook(14, i)];
      }
      dst[hook(1, dst_offset + dy * dstStep + dx)] = sum;
    }
  }
}