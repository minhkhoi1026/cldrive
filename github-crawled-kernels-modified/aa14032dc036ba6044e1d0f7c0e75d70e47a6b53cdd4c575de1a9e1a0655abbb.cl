//{"M":10,"coeffs":12,"dst":1,"dstStep":7,"dst_cols":4,"dst_offset":9,"dst_rows":5,"itab":16,"src":0,"srcStep":6,"src_cols":2,"src_offset":8,"src_rows":3,"tab1x":15,"tab1y":14,"threadCols":11,"v":13}
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

kernel void warpAffineCubic_C4_D0(global uchar4 const* restrict src, global uchar4* dst, int src_cols, int src_rows, int dst_cols, int dst_rows, int srcStep, int dstStep, int src_offset, int dst_offset, constant F* M, int threadCols) {
  int dx = get_global_id(0);
  int dy = get_global_id(1);

  if (dx < threadCols && dy < dst_rows) {
    int round_delta = (((1 << max(10, (int)5)) >> 5) >> 1);

    src_offset = (src_offset >> 2);
    srcStep = (srcStep >> 2);
    dst_offset = (dst_offset >> 2);
    dstStep = (dstStep >> 2);

    int tmp = (dx << max(10, (int)5));
    int X0 = rint(M[hook(10, 0)] * tmp);
    int Y0 = rint(M[hook(10, 3)] * tmp);
    X0 += rint((M[hook(10, 1)] * dy + M[hook(10, 2)]) * (1 << max(10, (int)5))) + round_delta;
    Y0 += rint((M[hook(10, 4)] * dy + M[hook(10, 5)]) * (1 << max(10, (int)5))) + round_delta;
    X0 = X0 >> (max(10, (int)5) - 5);
    Y0 = Y0 >> (max(10, (int)5) - 5);

    int sx = (short)(X0 >> 5) - 1;
    int sy = (short)(Y0 >> 5) - 1;
    int ay = (short)(Y0 & ((1 << 5) - 1));
    int ax = (short)(X0 & ((1 << 5) - 1));

    uchar4 v[16];
    int i, j;
    for (i = 0; i < 4; i++)
      for (j = 0; j < 4; j++) {
        v[hook(13, i * 4 + j)] = (sx + j >= 0 && sx + j < src_cols && sy + i >= 0 && sy + i < src_rows) ? (src[hook(0, src_offset + (sy + i) * srcStep + (sx + j))]) : (uchar4)0;
      }
    int itab[16];
    float tab1y[4], tab1x[4];
    float axx, ayy;

    ayy = 1.f / (1 << 5) * ay;
    axx = 1.f / (1 << 5) * ax;
    interpolateCubic(ayy, tab1y);
    interpolateCubic(axx, tab1x);
    int isum = 0;

    for (i = 0; i < 16; i++) {
      float tmp;
      tmp = tab1y[hook(14, (i >> 2))] * tab1x[hook(15, (i & 3))] * (1 << 15);
      itab[hook(16, i)] = rint(tmp);
      isum += itab[hook(16, i)];
    }

    if (isum != (1 << 15)) {
      int k1, k2;
      int diff = isum - (1 << 15);
      int Mk1 = 2, Mk2 = 2, mk1 = 2, mk2 = 2;

      for (k1 = 2; k1 < 4; k1++)
        for (k2 = 2; k2 < 4; k2++) {
          if (itab[hook(16, (k1 << 2) + k2)] < itab[hook(16, (mk1 << 2) + mk2)])
            mk1 = k1, mk2 = k2;
          else if (itab[hook(16, (k1 << 2) + k2)] > itab[hook(16, (Mk1 << 2) + Mk2)])
            Mk1 = k1, Mk2 = k2;
        }

      diff < 0 ? (itab[hook(16, (Mk1 << 2) + Mk2)] = (short)(itab[hook(16, (Mk1 << 2) + Mk2)] - diff)) : (itab[hook(16, (mk1 << 2) + mk2)] = (short)(itab[hook(16, (mk1 << 2) + mk2)] - diff));
    }

    if (dx >= 0 && dx < dst_cols && dy >= 0 && dy < dst_rows) {
      int4 sum = 0;
      for (i = 0; i < 16; i++) {
        sum += convert_int4(v[hook(13, i)]) * itab[hook(16, i)];
      }
      dst[hook(1, dst_offset + dy * dstStep + dx)] = convert_uchar4_sat((sum + (1 << (15 - 1))) >> 15);
    }
  }
}