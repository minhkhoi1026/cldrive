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

kernel void warpPerspectiveLinear_C1_D0(global const uchar* restrict src, global uchar* dst, int src_cols, int src_rows, int dst_cols, int dst_rows, int srcStep, int dstStep, int src_offset, int dst_offset, constant F* M, int threadCols) {
  int dx = get_global_id(0);
  int dy = get_global_id(1);

  if (dx < threadCols && dy < dst_rows) {
    F X0 = M[hook(10, 0)] * dx + M[hook(10, 1)] * dy + M[hook(10, 2)];
    F Y0 = M[hook(10, 3)] * dx + M[hook(10, 4)] * dy + M[hook(10, 5)];
    F W = M[hook(10, 6)] * dx + M[hook(10, 7)] * dy + M[hook(10, 8)];
    W = (W != 0.0f) ? (1 << 5) / W : 0.0f;
    int X = rint(X0 * W);
    int Y = rint(Y0 * W);

    int sx = convert_short_sat(X >> 5);
    int sy = convert_short_sat(Y >> 5);
    int ay = (short)(Y & ((1 << 5) - 1));
    int ax = (short)(X & ((1 << 5) - 1));

    uchar v[4];
    int i;
    for (i = 0; i < 4; i++)
      v[hook(13, i)] = (sx + (i & 1) >= 0 && sx + (i & 1) < src_cols && sy + (i >> 1) >= 0 && sy + (i >> 1) < src_rows) ? src[hook(0, src_offset + (sy + (i >> 1)) * srcStep + (sx + (i & 1)))] : (uchar)0;

    short itab[4];
    float tab1y[2], tab1x[2];
    tab1y[hook(14, 0)] = 1.0f - 1.f / (1 << 5) * ay;
    tab1y[hook(14, 1)] = 1.f / (1 << 5) * ay;
    tab1x[hook(15, 0)] = 1.0f - 1.f / (1 << 5) * ax;
    tab1x[hook(15, 1)] = 1.f / (1 << 5) * ax;

    for (i = 0; i < 4; i++) {
      float v = tab1y[hook(14, (i >> 1))] * tab1x[hook(15, (i & 1))];
      itab[hook(16, i)] = convert_short_sat_rte(v * (1 << 15));
    }
    if (dx >= 0 && dx < dst_cols && dy >= 0 && dy < dst_rows) {
      int sum = 0;
      for (i = 0; i < 4; i++) {
        sum += v[hook(13, i)] * itab[hook(16, i)];
      }
      dst[hook(1, dst_offset + dy * dstStep + dx)] = convert_uchar_sat((sum + (1 << (15 - 1))) >> 15);
    }
  }
}