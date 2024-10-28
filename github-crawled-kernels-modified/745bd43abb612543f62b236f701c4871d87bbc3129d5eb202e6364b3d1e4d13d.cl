//{"cols":3,"lm_sum":10,"lm_sum[0]":9,"lm_sum[1]":11,"lm_sum[lid >> 7]":12,"lm_sum[lid]":13,"rows":2,"src_step":4,"src_t":7,"srcsum":0,"sum":1,"sum_offset":6,"sum_p":14,"sum_step":5,"sum_t":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integral_sum_rows_D4(global int4* srcsum, global int* sum, int rows, int cols, int src_step, int sum_step, int sum_offset) {
  int lid = get_local_id(0);
  int gid = get_group_id(0);
  int4 src_t[2], sum_t[2];
  local int4 lm_sum[2][256 + 8];
  local int* sum_p;
  src_step = src_step >> 4;
  for (int i = 0; i < rows; i = i + 255) {
    src_t[hook(7, 0)] = i + lid < rows ? srcsum[hook(0, (lid + i) * src_step + gid * 2)] : 0;
    src_t[hook(7, 1)] = i + lid < rows ? srcsum[hook(0, (lid + i) * src_step + gid * 2 + 1)] : 0;

    sum_t[hook(8, 0)] = (i == 0 ? 0 : lm_sum[hook(10, 0)][hook(9, 254 + 8)]);
    sum_t[hook(8, 1)] = (i == 0 ? 0 : lm_sum[hook(10, 1)][hook(11, 254 + 8)]);
    barrier(0x01);

    int bf_loc = lid + ((lid) >> 5);
    lm_sum[hook(10, 0)][hook(9, bf_loc)] = src_t[hook(7, 0)];

    lm_sum[hook(10, 1)][hook(11, bf_loc)] = src_t[hook(7, 1)];

    int offset = 1;
    for (int d = 256 >> 1; d > 0; d >>= 1) {
      barrier(0x01);
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(10, lid >> 7)][hook(12, bi)] += lm_sum[hook(10, lid >> 7)][hook(12, ai)];
      }
      offset <<= 1;
    }
    barrier(0x01);
    if (lid < 2) {
      lm_sum[hook(10, lid)][hook(13, 254 + 8)] = 0;
    }
    for (int d = 1; d < 256; d <<= 1) {
      barrier(0x01);
      offset >>= 1;
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(10, lid >> 7)][hook(12, bi)] += lm_sum[hook(10, lid >> 7)][hook(12, ai)];
        lm_sum[hook(10, lid >> 7)][hook(12, ai)] = lm_sum[hook(10, lid >> 7)][hook(12, bi)] - lm_sum[hook(10, lid >> 7)][hook(12, ai)];
      }
    }
    barrier(0x01);
    if (gid == 0 && (i + lid) <= rows) {
      sum[hook(1, sum_offset + i + lid)] = 0;
    }
    if (i + lid == 0) {
      int loc0 = gid * 2 * sum_step;
      for (int k = 1; k <= 8; k++) {
        if (gid * 8 + k > cols)
          break;
        sum[hook(1, sum_offset + loc0 + k * sum_step / 4)] = 0;
      }
    }

    if (lid > 0 && (i + lid) <= rows) {
      int loc_s0 = sum_offset + gid * 2 * sum_step + sum_step / 4 + i + lid, loc_s1 = loc_s0 + sum_step;
      lm_sum[hook(10, 0)][hook(9, bf_loc)] += sum_t[hook(8, 0)];
      lm_sum[hook(10, 1)][hook(11, bf_loc)] += sum_t[hook(8, 1)];
      sum_p = (local int*)(&(lm_sum[hook(10, 0)][hook(9, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 8 + k >= cols)
          break;
        sum[hook(1, loc_s0 + k * sum_step / 4)] = sum_p[hook(14, k)];
      }
      sum_p = (local int*)(&(lm_sum[hook(10, 1)][hook(11, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 8 + 4 + k >= cols)
          break;
        sum[hook(1, loc_s1 + k * sum_step / 4)] = sum_p[hook(14, k)];
      }
    }
    barrier(0x01);
  }
}