//{"cols":5,"dst":2,"dst_step":3,"line":6,"line_out":7,"rows":4,"src":0,"src_step":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void boxFilter3x3_8UC1_cols16_rows2(global const unsigned int* src, int src_step, global unsigned int* dst, int dst_step, int rows, int cols) {
  int block_x = get_global_id(0);
  int y = get_global_id(1) * 2;
  int ssx, dsx;

  if ((block_x * 16) >= cols || y >= rows)
    return;

  uint4 line[4];
  uint4 line_out[2];
  ushort a;
  ushort16 b;
  ushort c;
  ushort d;
  ushort16 e;
  ushort f;
  ushort g;
  ushort16 h;
  ushort i;
  ushort j;
  ushort16 k;
  ushort l;

  ssx = dsx = 1;
  int src_index = block_x * 4 * ssx + (y - 1) * (src_step / 4);
  line[hook(6, 1)] = vload4(0, src + src_index + (src_step / 4));
  line[hook(6, 2)] = vload4(0, src + src_index + 2 * (src_step / 4));
  ushort16 sum, mid;
  global uchar* src_p = (global uchar*)src;

  src_index = block_x * 16 * ssx + (y - 1) * src_step;
  bool line_end = ((block_x + 1) * 16 == cols);

  b = convert_ushort16(__builtin_astype((line[hook(6, 0)]), uchar16));
  e = convert_ushort16(__builtin_astype((line[hook(6, 1)]), uchar16));
  h = convert_ushort16(__builtin_astype((line[hook(6, 2)]), uchar16));
  k = convert_ushort16(__builtin_astype((line[hook(6, 3)]), uchar16));
  mid = (ushort16)(d, e.s0123, e.s456789ab, e.scde) + e + (ushort16)(e.s123, e.s4567, e.s89abcdef, f) + (ushort16)(g, h.s0123, h.s456789ab, h.scde) + h + (ushort16)(h.s123, h.s4567, h.s89abcdef, i);

  sum = (ushort16)(a, b.s0123, b.s456789ab, b.scde) + b + (ushort16)(b.s123, b.s4567, b.s89abcdef, c) + mid;

  line_out[hook(7, 0)] = __builtin_astype((convert_uchar16_sat_rte(sum)), uint4);

  sum = mid + (ushort16)(j, k.s0123, k.s456789ab, k.scde) + k + (ushort16)(k.s123, k.s4567, k.s89abcdef, l);

  line_out[hook(7, 1)] = __builtin_astype((convert_uchar16_sat_rte(sum)), uint4);

  int dst_index = block_x * 4 * dsx + y * (dst_step / 4);
  vstore4(line_out[hook(7, 0)], 0, dst + dst_index);
  vstore4(line_out[hook(7, 1)], 0, dst + dst_index + (dst_step / 4));
}