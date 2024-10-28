//{"M":10,"coeffs":12,"dst":1,"dstStep":7,"dst_cols":4,"dst_offset":9,"dst_rows":5,"src":0,"srcStep":6,"src_cols":2,"src_offset":8,"src_rows":3,"threadCols":11}
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

kernel void warpAffineNN_C4_D5(global float4* src, global float4* dst, int src_cols, int src_rows, int dst_cols, int dst_rows, int srcStep, int dstStep, int src_offset, int dst_offset, constant F* M, int threadCols) {
  int dx = get_global_id(0);
  int dy = get_global_id(1);

  if (dx < threadCols && dy < dst_rows) {
    int round_delta = (1 << max(10, (int)5)) / 2;

    int X0 = rint(M[hook(10, 0)] * dx * (1 << max(10, (int)5)));
    int Y0 = rint(M[hook(10, 3)] * dx * (1 << max(10, (int)5)));
    X0 += rint((M[hook(10, 1)] * dy + M[hook(10, 2)]) * (1 << max(10, (int)5))) + round_delta;
    Y0 += rint((M[hook(10, 4)] * dy + M[hook(10, 5)]) * (1 << max(10, (int)5))) + round_delta;

    short sx0 = (short)(X0 >> max(10, (int)5));
    short sy0 = (short)(Y0 >> max(10, (int)5));

    if (dx >= 0 && dx < dst_cols && dy >= 0 && dy < dst_rows)
      dst[hook(1, (dst_offset >> 4) + dy * (dstStep >> 2) + dx)] = (sx0 >= 0 && sx0 < src_cols && sy0 >= 0 && sy0 < src_rows) ? src[hook(0, (src_offset >> 4) + sy0 * (srcStep >> 2) + sx0)] : (float4)0;
  }
}