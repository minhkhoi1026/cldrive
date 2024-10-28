//{"final_g":6,"input":0,"mask_coeffs":2,"output_gauss":1,"result_cur":4,"result_next":5,"result_pre":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const float coeffs[9] = {0.0f, 0.0f, 0.152f, 0.222f, 0.252f, 0.222f, 0.152f, 0.0f, 0.0f};
inline float8 read_scale_y(read_only image2d_t input, const sampler_t sampler, float2 pos_start, float step_x) {
  float8 data;
  data.s0 = read_imagef(input, sampler, pos_start).x;
  pos_start.x += step_x;
  data.s1 = read_imagef(input, sampler, pos_start).x;
  pos_start.x += step_x;
  data.s2 = read_imagef(input, sampler, pos_start).x;
  pos_start.x += step_x;
  data.s3 = read_imagef(input, sampler, pos_start).x;
  pos_start.x += step_x;
  data.s4 = read_imagef(input, sampler, pos_start).x;
  pos_start.x += step_x;
  data.s5 = read_imagef(input, sampler, pos_start).x;
  pos_start.x += step_x;
  data.s6 = read_imagef(input, sampler, pos_start).x;
  pos_start.x += step_x;
  data.s7 = read_imagef(input, sampler, pos_start).x;
  return data;
}

inline float8 read_scale_uv(read_only image2d_t input, const sampler_t sampler, float2 pos_start, float step_x) {
  float8 data;
  data.s01 = read_imagef(input, sampler, pos_start).xy;
  pos_start.x += step_x;
  data.s23 = read_imagef(input, sampler, pos_start).xy;
  pos_start.x += step_x;
  data.s45 = read_imagef(input, sampler, pos_start).xy;
  pos_start.x += step_x;
  data.s67 = read_imagef(input, sampler, pos_start).xy;
  return data;
}

__inline int pos_buf_index(int x, int y, int stride) {
  return mad24(stride, y, x);
}

constant const float mask_coeffs[] = {0.0f, 0.0f, 0.0f, 0.082f, 0.102f, 0.119f, 0.130f, 0.134f, 0.130f, 0.119f, 0.102f, 0.082f, 0.0f, 0.0f, 0.0f};

kernel void kernel_mask_gauss_scale(read_only image2d_t input, write_only image2d_t output_gauss

) {
  int g_x = get_global_id(0);
  int in_x = g_x;
  int g_y = get_global_id(1) * 2;
  const sampler_t sampler = 0 | 2 | 0x10;

  float8 result_pre[2] = {(float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f), (float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f)};
  float8 result_next[2] = {(float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f), (float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f)};
  float8 result_cur[2] = {(float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f), (float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f)};
  float8 final_g[2];

  float8 tmp_data;
  int i_line;
  int cur_g_y;
  float coeff0, coeff1;

  for (i_line = -4; i_line <= 4 + 1; i_line++) {
    cur_g_y = g_y + i_line;
    coeff0 = mask_coeffs[hook(2, i_line + 7)];
    coeff1 = mask_coeffs[hook(2, i_line + 7 - 1)];
    tmp_data = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(in_x - 1, cur_g_y)))), uchar8));
    result_pre[hook(3, 0)] += tmp_data * coeff0;
    result_pre[hook(3, 1)] += tmp_data * coeff1;

    tmp_data = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(in_x, cur_g_y)))), uchar8));
    result_cur[hook(4, 0)] += tmp_data * coeff0;
    result_cur[hook(4, 1)] += tmp_data * coeff1;
    tmp_data = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(in_x + 1, cur_g_y)))), uchar8));
    result_next[hook(5, 1)] += tmp_data * coeff1;
    result_next[hook(5, 0)] += tmp_data * coeff0;
  }

  for (i_line = 0; i_line < 2; ++i_line) {
    final_g[hook(6, i_line)] = result_cur[hook(4, i_line)] * mask_coeffs[hook(2, 7)] + (float8)(result_pre[hook(3, i_line)].s7, result_cur[hook(4, i_line)].s0123, result_cur[hook(4, i_line)].s456) * mask_coeffs[hook(2, 7 + 1)] + (float8)(result_cur[hook(4, i_line)].s1234, result_cur[hook(4, i_line)].s567, result_next[hook(5, i_line)].s0) * mask_coeffs[hook(2, 7 + 1)] + (float8)(result_pre[hook(3, i_line)].s67, result_cur[hook(4, i_line)].s0123, result_cur[hook(4, i_line)].s45) * mask_coeffs[hook(2, 7 + 2)] + (float8)(result_cur[hook(4, i_line)].s2345, result_cur[hook(4, i_line)].s67, result_next[hook(5, i_line)].s01) * mask_coeffs[hook(2, 7 + 2)] + (float8)(result_pre[hook(3, i_line)].s567, result_cur[hook(4, i_line)].s0123, result_cur[hook(4, i_line)].s4) * mask_coeffs[hook(2, 7 + 3)] + (float8)(result_cur[hook(4, i_line)].s3456, result_cur[hook(4, i_line)].s7, result_next[hook(5, i_line)].s012) * mask_coeffs[hook(2, 7 + 3)] + (float8)(result_pre[hook(3, i_line)].s4567, result_cur[hook(4, i_line)].s0123) * mask_coeffs[hook(2, 7 + 4)] + (float8)(result_cur[hook(4, i_line)].s4567, result_next[hook(5, i_line)].s0123) * mask_coeffs[hook(2, 7 + 4)];
    final_g[hook(6, i_line)] = clamp(final_g[hook(6, i_line)] + 0.5f, 0.0f, 255.0f);
    write_imageui(output_gauss, (int2)(g_x, g_y + i_line), convert_uint4(__builtin_astype((convert_uchar8(final_g[hook(6, i_line)])), ushort4)));
  }
}