//{"((__local ushort8 *)(slm_gauss_y[0]))":5,"((__local ushort8 *)(slm_gauss_y[1]))":7,"final_g":9,"image_width":2,"input":0,"mask_coeffs":4,"output_gauss":1,"result_cur":3,"slm_gauss_y":6,"slm_gauss_y[i_line]":8}
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

kernel void kernel_mask_gauss_scale_slm(read_only image2d_t input, write_only image2d_t output_gauss, int image_width

) {
  int g_x = get_global_id(0);
  int g_y = get_global_id(1) * 2;
  const sampler_t sampler = 0 | 2 | 0x10;
  local ushort4 slm_gauss_y[2][256];

  float8 result_cur[2] = {(float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f), (float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f)};
  float8 tmp_data;
  int i_line;
  int cur_g_y;

  for (i_line = -4; i_line <= 4 + 1; i_line++) {
    cur_g_y = g_y + i_line;
    tmp_data = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(g_x, cur_g_y)))), uchar8));
    result_cur[hook(3, 0)] += tmp_data * mask_coeffs[hook(4, i_line + 7)];
    result_cur[hook(3, 1)] += tmp_data * mask_coeffs[hook(4, i_line + 7 - 1)];
  }
  ((local ushort8*)(slm_gauss_y[hook(6, 0)]))[hook(5, g_x)] = convert_ushort8(result_cur[hook(3, 0)] * 128.0f);
  ((local ushort8*)(slm_gauss_y[hook(6, 1)]))[hook(7, g_x)] = convert_ushort8(result_cur[hook(3, 1)] * 128.0f);
  barrier(0x01);

  float8 final_g[2];
  float4 result_pre;
  float4 result_next;

  for (i_line = 0; i_line < 2; ++i_line) {
    result_pre = convert_float4(slm_gauss_y[hook(6, i_line)][hook(8, clamp(g_x * 2 - 1, 0, image_width * 2))]) / 128.0f;
    result_next = convert_float4(slm_gauss_y[hook(6, i_line)][hook(8, clamp(g_x * 2 + 2, 0, image_width * 2))]) / 128.0f;
    final_g[hook(9, i_line)] = result_cur[hook(3, i_line)] * mask_coeffs[hook(4, 7)] + (float8)(result_pre.s3, result_cur[hook(3, i_line)].s0123, result_cur[hook(3, i_line)].s456) * mask_coeffs[hook(4, 7 + 1)] + (float8)(result_cur[hook(3, i_line)].s1234, result_cur[hook(3, i_line)].s567, result_next.s0) * mask_coeffs[hook(4, 7 + 1)] + (float8)(result_pre.s23, result_cur[hook(3, i_line)].s0123, result_cur[hook(3, i_line)].s45) * mask_coeffs[hook(4, 7 + 2)] + (float8)(result_cur[hook(3, i_line)].s2345, result_cur[hook(3, i_line)].s67, result_next.s01) * mask_coeffs[hook(4, 7 + 2)] + (float8)(result_pre.s123, result_cur[hook(3, i_line)].s0123, result_cur[hook(3, i_line)].s4) * mask_coeffs[hook(4, 7 + 3)] + (float8)(result_cur[hook(3, i_line)].s3456, result_cur[hook(3, i_line)].s7, result_next.s012) * mask_coeffs[hook(4, 7 + 3)] + (float8)(result_pre.s0123, result_cur[hook(3, i_line)].s0123) * mask_coeffs[hook(4, 7 + 4)] + (float8)(result_cur[hook(3, i_line)].s4567, result_next.s0123) * mask_coeffs[hook(4, 7 + 4)];
    final_g[hook(9, i_line)] = clamp(final_g[hook(9, i_line)] + 0.5f, 0.0f, 255.0f);

    write_imageui(output_gauss, (int2)(g_x, g_y + i_line), convert_uint4(__builtin_astype((convert_uchar8(final_g[hook(9, i_line)])), ushort4)));
  }
}