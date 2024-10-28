//{"cols":5,"dst_step":7,"lm_sum":11,"lm_sum[0]":10,"lm_sum[1]":12,"lm_sum[lid >> 7]":13,"lm_sum[lid]":14,"pre_invalid":3,"rows":4,"src":0,"src_offset":2,"src_step":6,"src_t":8,"sum":1,"sum_p":15,"sum_t":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integral_sum_cols_D5(global uchar4* src, global float* sum, int src_offset, int pre_invalid, int rows, int cols, int src_step, int dst_step) {
  int lid = get_local_id(0);
  int gid = get_group_id(0);
  float4 src_t[2], sum_t[2];
  local float4 lm_sum[2][256 + 8];
  local float* sum_p;
  src_step = src_step >> 2;
  gid = gid << 1;
  for (int i = 0; i < rows; i = i + 255) {
    src_t[hook(8, 0)] = (i + lid < rows ? convert_float4(src[hook(0, src_offset + (lid + i) * src_step + gid)]) : (float4)0);
    src_t[hook(8, 1)] = (i + lid < rows ? convert_float4(src[hook(0, src_offset + (lid + i) * src_step + gid + 1)]) : (float4)0);

    sum_t[hook(9, 0)] = (i == 0 ? (float4)0 : lm_sum[hook(11, 0)][hook(10, 254 + 8)]);
    sum_t[hook(9, 1)] = (i == 0 ? (float4)0 : lm_sum[hook(11, 1)][hook(12, 254 + 8)]);
    barrier(0x01);

    int bf_loc = lid + ((lid) >> 5);
    lm_sum[hook(11, 0)][hook(10, bf_loc)] = src_t[hook(8, 0)];

    lm_sum[hook(11, 1)][hook(12, bf_loc)] = src_t[hook(8, 1)];

    int offset = 1;
    for (int d = 256 >> 1; d > 0; d >>= 1) {
      barrier(0x01);
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(11, lid >> 7)][hook(13, bi)] += lm_sum[hook(11, lid >> 7)][hook(13, ai)];
      }
      offset <<= 1;
    }
    barrier(0x01);
    if (lid < 2) {
      lm_sum[hook(11, lid)][hook(14, 254 + 8)] = 0;
    }
    for (int d = 1; d < 256; d <<= 1) {
      barrier(0x01);
      offset >>= 1;
      int ai = offset * (((lid & 127) << 1) + 1) - 1, bi = ai + offset;
      ai += ((ai) >> 5);
      bi += ((bi) >> 5);

      if ((lid & 127) < d) {
        lm_sum[hook(11, lid >> 7)][hook(13, bi)] += lm_sum[hook(11, lid >> 7)][hook(13, ai)];
        lm_sum[hook(11, lid >> 7)][hook(13, ai)] = lm_sum[hook(11, lid >> 7)][hook(13, bi)] - lm_sum[hook(11, lid >> 7)][hook(13, ai)];
      }
    }
    barrier(0x01);
    if (lid > 0 && (i + lid) <= rows) {
      int loc_s0 = gid * dst_step + i + lid - 1 - pre_invalid * dst_step / 4, loc_s1 = loc_s0 + dst_step;
      lm_sum[hook(11, 0)][hook(10, bf_loc)] += sum_t[hook(9, 0)];
      lm_sum[hook(11, 1)][hook(12, bf_loc)] += sum_t[hook(9, 1)];
      sum_p = (local float*)(&(lm_sum[hook(11, 0)][hook(10, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 4 + k >= cols + pre_invalid || gid * 4 + k < pre_invalid)
          continue;
        sum[hook(1, loc_s0 + k * dst_step / 4)] = sum_p[hook(15, k)];
      }
      sum_p = (local float*)(&(lm_sum[hook(11, 1)][hook(12, bf_loc)]));
      for (int k = 0; k < 4; k++) {
        if (gid * 4 + k + 4 >= cols + pre_invalid)
          break;
        sum[hook(1, loc_s1 + k * dst_step / 4)] = sum_p[hook(15, k)];
      }
    }
    barrier(0x01);
  }
}