//{"input_dark":1,"input_y":0,"output_dark":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline void calc_sum(float8 cur_y, float8 cur_dark, float8 center_y, float8* weight_sum, float8* data_sum) {
  float8 delta = (cur_y - center_y) / 28.0f;
  delta = -0.5f * delta * delta;

  float8 weight = native_exp(delta);
  float8 data = cur_dark * weight;
  (*weight_sum) += weight;
  (*data_sum) += data;
}

kernel void kernel_bi_filter(read_only image2d_t input_y, read_only image2d_t input_dark, write_only image2d_t output_dark) {
  int pos_x = get_global_id(0);
  int pos_y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;

  float8 y1, y2, dark1, dark2;
  float8 cur_y, cur_dark;

  float8 weight_sum = 0.0f;
  float8 data_sum = 0.0f;
  float8 center_y = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_y, sampler, (int2)(pos_x, pos_y)))), uchar8));
  for (int i = 0; i < (2 * 7 + 1); i++) {
    y1 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_y, sampler, (int2)(pos_x - 1, pos_y - 7 + i)))), uchar8));
    y2 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_y, sampler, (int2)(pos_x, pos_y - 7 + i)))), uchar8));
    dark1 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_dark, sampler, (int2)(pos_x - 1, pos_y - 7 + i)))), uchar8));
    dark2 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_dark, sampler, (int2)(pos_x, pos_y - 7 + i)))), uchar8));
    cur_y = (float8)(y1.s1234, y1.s567, y2.s0);
    cur_dark = (float8)(dark1.s1234, dark1.s567, dark2.s0);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y1.s2345, y1.s67, y2.s01);
    cur_dark = (float8)(dark1.s2345, dark1.s67, dark2.s01);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y1.s3456, y1.s7, y2.s012);
    cur_dark = (float8)(dark1.s3456, dark1.s7, dark2.s012);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y1.s4567, y2.s01, y2.s23);
    cur_dark = (float8)(dark1.s4567, dark2.s01, dark2.s23);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y1.s567, y2.s0123, y2.s4);
    cur_dark = (float8)(dark1.s567, dark2.s0123, dark2.s4);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y1.s67, y2.s0123, y2.s45);
    cur_dark = (float8)(dark1.s67, dark2.s0123, dark2.s45);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y1.s7, y2.s0123, y2.s456);
    cur_dark = (float8)(dark1.s7, dark2.s0123, dark2.s456);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y2.s0123, y2.s45, y2.s67);
    cur_dark = (float8)(dark2.s0123, dark2.s45, dark2.s67);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;

    y1 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_y, sampler, (int2)(pos_x + 1, pos_y - 7 + i)))), uchar8));
    dark1 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_dark, sampler, (int2)(pos_x + 1, pos_y - 7 + i)))), uchar8));
    cur_y = (float8)(y2.s1234, y2.s567, y1.s0);
    cur_dark = (float8)(dark2.s1234, dark2.s567, dark1.s0);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y2.s2345, y2.s67, y1.s01);
    cur_dark = (float8)(dark2.s2345, dark2.s67, dark1.s01);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y2.s3456, y2.s7, y1.s012);
    cur_dark = (float8)(dark2.s3456, dark2.s7, dark1.s012);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y2.s4567, y1.s01, y1.s23);
    cur_dark = (float8)(dark2.s4567, dark1.s01, dark1.s23);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y2.s567, y1.s0123, y1.s4);
    cur_dark = (float8)(dark2.s567, dark1.s0123, dark1.s4);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y2.s67, y1.s0123, y1.s45);
    cur_dark = (float8)(dark2.s67, dark1.s0123, dark1.s45);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
    cur_y = (float8)(y2.s7, y1.s0123, y1.s456);
    cur_dark = (float8)(dark2.s7, dark1.s0123, dark1.s456);
    calc_sum(cur_y, cur_dark, center_y, &weight_sum, &data_sum);
    ;
  }

  float8 out_data = data_sum / weight_sum;
  write_imageui(output_dark, (int2)(pos_x, pos_y), convert_uint4(__builtin_astype((convert_uchar8(out_data)), ushort4)));
}