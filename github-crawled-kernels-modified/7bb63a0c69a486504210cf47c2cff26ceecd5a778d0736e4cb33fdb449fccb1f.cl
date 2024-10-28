//{"M":10,"dst":5,"dst_cols":9,"dst_offset":7,"dst_rows":8,"dst_step":6,"src":0,"src_cols":4,"src_offset":2,"src_rows":3,"src_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void warpPerspective(global const uchar* src, int src_step, int src_offset, int src_rows, int src_cols, global uchar* dst, int dst_step, int dst_offset, int dst_rows, int dst_cols, constant float* M) {
  int dx = get_global_id(0);
  int dy = get_global_id(1);

  if (dx < dst_cols && dy < dst_rows) {
    float X0 = M[hook(10, 0)] * dx + M[hook(10, 1)] * dy + M[hook(10, 2)];
    float Y0 = M[hook(10, 3)] * dx + M[hook(10, 4)] * dy + M[hook(10, 5)];
    float W = M[hook(10, 6)] * dx + M[hook(10, 7)] * dy + M[hook(10, 8)];
    W = W != 0.0f ? (1 << 5) / W : 0.0f;
    int X = rint(X0 * W), Y = rint(Y0 * W);

    short sx = convert_short_sat(X >> 5);
    short sy = convert_short_sat(Y >> 5);
    short ay = (short)(Y & ((1 << 5) - 1));
    short ax = (short)(X & ((1 << 5) - 1));

    int v0 = (sx >= 0 && sx < src_cols && sy >= 0 && sy < src_rows) ? convert_int(src[hook(0, mad24(sy, src_step, src_offset + sx))]) : 0;
    int v1 = (sx + 1 >= 0 && sx + 1 < src_cols && sy >= 0 && sy < src_rows) ? convert_int(src[hook(0, mad24(sy, src_step, src_offset + (sx + 1)))]) : 0;
    int v2 = (sx >= 0 && sx < src_cols && sy + 1 >= 0 && sy + 1 < src_rows) ? convert_int(src[hook(0, mad24(sy + 1, src_step, src_offset + sx))]) : 0;
    int v3 = (sx + 1 >= 0 && sx + 1 < src_cols && sy + 1 >= 0 && sy + 1 < src_rows) ? convert_int(src[hook(0, mad24(sy + 1, src_step, src_offset + (sx + 1)))]) : 0;

    float taby = 1.f / (1 << 5) * ay;
    float tabx = 1.f / (1 << 5) * ax;

    int dst_index = mad24(dy, dst_step, dst_offset + dx);

    int itab0 = convert_short_sat_rte((1.0f - taby) * (1.0f - tabx) * (1 << 15));
    int itab1 = convert_short_sat_rte((1.0f - taby) * tabx * (1 << 15));
    int itab2 = convert_short_sat_rte(taby * (1.0f - tabx) * (1 << 15));
    int itab3 = convert_short_sat_rte(taby * tabx * (1 << 15));

    int val = v0 * itab0 + v1 * itab1 + v2 * itab2 + v3 * itab3;

    uchar pix = convert_uchar_sat((val + (1 << (15 - 1))) >> 15);
    dst[hook(5, dst_index)] = pix;
  }
}