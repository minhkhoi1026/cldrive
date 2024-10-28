//{"cols":6,"dst_step":8,"lm_sqsum":15,"lm_sqsum[0]":14,"lm_sqsum[1]":17,"lm_sqsum[lid >> 7]":19,"lm_sqsum[lid]":21,"lm_sum":12,"lm_sum[0]":11,"lm_sum[1]":16,"lm_sum[lid >> 7]":18,"lm_sum[lid]":20,"pre_invalid":4,"rows":5,"sqsum":2,"sqsum_p":23,"sqsum_t":13,"src":0,"src_offset":3,"src_step":7,"src_t":9,"sum":1,"sum_p":22,"sum_t":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integral_cols_D4(global uchar4* src, global int* sum, global float* sqsum, int src_offset, int pre_invalid, int rows, int cols, int src_step, int dst_step) {
  int lid = get_local_id(0);
  int gid = get_group_id(0);
  int4 src_t[2], sum_t[2];
  float4 sqsum_t[2];
  local int4 lm_sum[2][256 + 8];
  local float4 lm_sqsum[2][256 + 8];
  local int* sum_p;
  local float* sqsum_p;
  src_step = src_step >> 2;
  gid = gid << 1;
  for (int i = 0; i < rows; i = i + 255) {
    src_t[hook(9, 0)] = (i + lid < rows ? convert_int4(src[hook(0, src_offset + (lid + i) * src_step + min(gid, cols - 1))]) : 0);
    src_t[hook(9, 1)] = (i + lid < rows ? convert_int4(src[hook(0, src_offset + (lid + i) * src_step + min(gid + 1, cols - 1))]) : 0);

    sum_t[hook(10, 0)] = (i == 0 ? 0 : lm_sum[hook(12, 0)][hook(11, 254 + 8)]);
    sqsum_t[hook(13, 0)] = (i == 0 ? (float4)0 : lm_sqsum[hook(15, 0)][hook(14, 254 + 8)]);
    sum_t[hook(10, 1)] = (i == 0 ? 0 : lm_sum[hook(12, 1)][hook(16, 254 + 8)]);
    sqsum_t[hook(13, 1)] = (i == 0 ? (float4)0 : lm_sqsum[hook(15, 1)][hook(17, 254 + 8)]);
    barrier(0x01);

    int bf_loc = lid + ((lid) >> 5);
    lm_sum[hook(12, 0)][hook(11, bf_loc)] = src_t[hook(9, 0)];
    lm_sqsum[hook(15, 0)][hook(14, bf_loc)] = convert_float4(src_t[hook(9, 0)] * src_t[hook(9, 0)]);

    lm_sum[hook(12, 1)][hook(16, bf_loc)] = src_t[hook(9, 1)];
    lm_sqsum[hook(15, 1)][hook(17, bf_loc)] = convert_float4(src_t[hook(9, 1)] * src_t[hook(9, 1)]);

    int offset = 1;
    for (int d = 256 >> 1; d > 0; d >>= 1) {
      barrier(0x01);
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(12, lid >> 7)][hook(18, bi)] += lm_sum[hook(12, lid >> 7)][hook(18, ai)];
        lm_sqsum[hook(15, lid >> 7)][hook(19, bi)] += lm_sqsum[hook(15, lid >> 7)][hook(19, ai)];
      }
      offset <<= 1;
    }
    barrier(0x01);
    if (lid < 2) {
      lm_sum[hook(12, lid)][hook(20, 254 + 8)] = 0;
      lm_sqsum[hook(15, lid)][hook(21, 254 + 8)] = 0;
    }
    for (int d = 1; d < 256; d <<= 1) {
      barrier(0x01);
      offset >>= 1;
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(12, lid >> 7)][hook(18, bi)] += lm_sum[hook(12, lid >> 7)][hook(18, ai)];
        lm_sum[hook(12, lid >> 7)][hook(18, ai)] = lm_sum[hook(12, lid >> 7)][hook(18, bi)] - lm_sum[hook(12, lid >> 7)][hook(18, ai)];

        lm_sqsum[hook(15, lid >> 7)][hook(19, bi)] += lm_sqsum[hook(15, lid >> 7)][hook(19, ai)];
        lm_sqsum[hook(15, lid >> 7)][hook(19, ai)] = lm_sqsum[hook(15, lid >> 7)][hook(19, bi)] - lm_sqsum[hook(15, lid >> 7)][hook(19, ai)];
      }
    }
    barrier(0x01);
    int loc_s0 = gid * dst_step + i + lid - 1 - pre_invalid * dst_step / 4, loc_s1 = loc_s0 + dst_step;
    if (lid > 0 && (i + lid) <= rows) {
      lm_sum[hook(12, 0)][hook(11, bf_loc)] += sum_t[hook(10, 0)];
      lm_sum[hook(12, 1)][hook(16, bf_loc)] += sum_t[hook(10, 1)];
      lm_sqsum[hook(15, 0)][hook(14, bf_loc)] += sqsum_t[hook(13, 0)];
      lm_sqsum[hook(15, 1)][hook(17, bf_loc)] += sqsum_t[hook(13, 1)];
      sum_p = (local int*)(&(lm_sum[hook(12, 0)][hook(11, bf_loc)]));
      sqsum_p = (local float*)(&(lm_sqsum[hook(15, 0)][hook(14, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 4 + k >= cols + pre_invalid || gid * 4 + k < pre_invalid)
          continue;
        sum[hook(1, loc_s0 + k * dst_step / 4)] = sum_p[hook(22, k)];
        sqsum[hook(2, loc_s0 + k * dst_step / 4)] = sqsum_p[hook(23, k)];
      }
      sum_p = (local int*)(&(lm_sum[hook(12, 1)][hook(16, bf_loc)]));
      sqsum_p = (local float*)(&(lm_sqsum[hook(15, 1)][hook(17, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 4 + k + 4 >= cols + pre_invalid)
          break;
        sum[hook(1, loc_s1 + k * dst_step / 4)] = sum_p[hook(22, k)];
        sqsum[hook(2, loc_s1 + k * dst_step / 4)] = sqsum_p[hook(23, k)];
      }
    }
    barrier(0x01);
  }
}