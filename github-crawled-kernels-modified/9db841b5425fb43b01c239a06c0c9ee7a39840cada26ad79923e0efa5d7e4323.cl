//{"cols":5,"lm_sqsum":18,"lm_sqsum[0]":17,"lm_sqsum[1]":20,"lm_sqsum[lid >> 7]":22,"lm_sqsum[lid]":24,"lm_sum":15,"lm_sum[0]":14,"lm_sum[1]":19,"lm_sum[lid >> 7]":21,"lm_sum[lid]":23,"rows":4,"sqsrc_t":12,"sqsum":3,"sqsum_offset":10,"sqsum_p":26,"sqsum_step":8,"sqsum_t":16,"src_step":6,"src_t":11,"srcsqsum":1,"srcsum":0,"sum":2,"sum_offset":9,"sum_p":25,"sum_step":7,"sum_t":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integral_rows_D4(global int4* srcsum, global float4* srcsqsum, global int* sum, global float* sqsum, int rows, int cols, int src_step, int sum_step, int sqsum_step, int sum_offset, int sqsum_offset) {
  int lid = get_local_id(0);
  int gid = get_group_id(0);
  int4 src_t[2], sum_t[2];
  float4 sqsrc_t[2], sqsum_t[2];
  local int4 lm_sum[2][256 + 8];
  local float4 lm_sqsum[2][256 + 8];
  local int* sum_p;
  local float* sqsum_p;
  src_step = src_step >> 4;
  for (int i = 0; i < rows; i = i + 255) {
    src_t[hook(11, 0)] = i + lid < rows ? srcsum[hook(0, (lid + i) * src_step + gid * 2)] : (int4)0;
    sqsrc_t[hook(12, 0)] = i + lid < rows ? srcsqsum[hook(1, (lid + i) * src_step + gid * 2)] : (float4)0;
    src_t[hook(11, 1)] = i + lid < rows ? srcsum[hook(0, (lid + i) * src_step + gid * 2 + 1)] : (int4)0;
    sqsrc_t[hook(12, 1)] = i + lid < rows ? srcsqsum[hook(1, (lid + i) * src_step + gid * 2 + 1)] : (float4)0;

    sum_t[hook(13, 0)] = (i == 0 ? 0 : lm_sum[hook(15, 0)][hook(14, 254 + 8)]);
    sqsum_t[hook(16, 0)] = (i == 0 ? (float4)0 : lm_sqsum[hook(18, 0)][hook(17, 254 + 8)]);
    sum_t[hook(13, 1)] = (i == 0 ? 0 : lm_sum[hook(15, 1)][hook(19, 254 + 8)]);
    sqsum_t[hook(16, 1)] = (i == 0 ? (float4)0 : lm_sqsum[hook(18, 1)][hook(20, 254 + 8)]);
    barrier(0x01);

    int bf_loc = lid + ((lid) >> 5);
    lm_sum[hook(15, 0)][hook(14, bf_loc)] = src_t[hook(11, 0)];
    lm_sqsum[hook(18, 0)][hook(17, bf_loc)] = sqsrc_t[hook(12, 0)];

    lm_sum[hook(15, 1)][hook(19, bf_loc)] = src_t[hook(11, 1)];
    lm_sqsum[hook(18, 1)][hook(20, bf_loc)] = sqsrc_t[hook(12, 1)];

    int offset = 1;
    for (int d = 256 >> 1; d > 0; d >>= 1) {
      barrier(0x01);
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(15, lid >> 7)][hook(21, bi)] += lm_sum[hook(15, lid >> 7)][hook(21, ai)];
        lm_sqsum[hook(18, lid >> 7)][hook(22, bi)] += lm_sqsum[hook(18, lid >> 7)][hook(22, ai)];
      }
      offset <<= 1;
    }
    barrier(0x01);
    if (lid < 2) {
      lm_sum[hook(15, lid)][hook(23, 254 + 8)] = 0;
      lm_sqsum[hook(18, lid)][hook(24, 254 + 8)] = 0;
    }
    for (int d = 1; d < 256; d <<= 1) {
      barrier(0x01);
      offset >>= 1;
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(15, lid >> 7)][hook(21, bi)] += lm_sum[hook(15, lid >> 7)][hook(21, ai)];
        lm_sum[hook(15, lid >> 7)][hook(21, ai)] = lm_sum[hook(15, lid >> 7)][hook(21, bi)] - lm_sum[hook(15, lid >> 7)][hook(21, ai)];

        lm_sqsum[hook(18, lid >> 7)][hook(22, bi)] += lm_sqsum[hook(18, lid >> 7)][hook(22, ai)];
        lm_sqsum[hook(18, lid >> 7)][hook(22, ai)] = lm_sqsum[hook(18, lid >> 7)][hook(22, bi)] - lm_sqsum[hook(18, lid >> 7)][hook(22, ai)];
      }
    }
    barrier(0x01);
    if (gid == 0 && (i + lid) <= rows) {
      sum[hook(2, sum_offset + i + lid)] = 0;
      sqsum[hook(3, sqsum_offset + i + lid)] = 0;
    }
    if (i + lid == 0) {
      int loc0 = gid * 2 * sum_step;
      int loc1 = gid * 2 * sqsum_step;
      for (int k = 1; k <= 8; k++) {
        if (gid * 8 + k > cols)
          break;
        sum[hook(2, sum_offset + loc0 + k * sum_step / 4)] = 0;
        sqsum[hook(3, sqsum_offset + loc1 + k * sqsum_step / 4)] = 0;
      }
    }
    int loc_s0 = sum_offset + gid * 2 * sum_step + sum_step / 4 + i + lid, loc_s1 = loc_s0 + sum_step;
    int loc_sq0 = sqsum_offset + gid * 2 * sqsum_step + sqsum_step / 4 + i + lid, loc_sq1 = loc_sq0 + sqsum_step;
    if (lid > 0 && (i + lid) <= rows) {
      lm_sum[hook(15, 0)][hook(14, bf_loc)] += sum_t[hook(13, 0)];
      lm_sum[hook(15, 1)][hook(19, bf_loc)] += sum_t[hook(13, 1)];
      lm_sqsum[hook(18, 0)][hook(17, bf_loc)] += sqsum_t[hook(16, 0)];
      lm_sqsum[hook(18, 1)][hook(20, bf_loc)] += sqsum_t[hook(16, 1)];
      sum_p = (local int*)(&(lm_sum[hook(15, 0)][hook(14, bf_loc)]));
      sqsum_p = (local float*)(&(lm_sqsum[hook(18, 0)][hook(17, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 8 + k >= cols)
          break;
        sum[hook(2, loc_s0 + k * sum_step / 4)] = sum_p[hook(25, k)];
        sqsum[hook(3, loc_sq0 + k * sqsum_step / 4)] = sqsum_p[hook(26, k)];
      }
      sum_p = (local int*)(&(lm_sum[hook(15, 1)][hook(19, bf_loc)]));
      sqsum_p = (local float*)(&(lm_sqsum[hook(18, 1)][hook(20, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 8 + 4 + k >= cols)
          break;
        sum[hook(2, loc_s1 + k * sum_step / 4)] = sum_p[hook(25, k)];
        sqsum[hook(3, loc_sq1 + k * sqsum_step / 4)] = sqsum_p[hook(26, k)];
      }
    }
    barrier(0x01);
  }
}