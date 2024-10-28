//{"coeffs":3,"final_g":7,"in_offset_x":1,"input":0,"output_gauss":2,"result_cur":5,"result_next":6,"result_pre":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const float coeffs[9] = {0.0f, 0.0f, 0.152f, 0.222f, 0.252f, 0.222f, 0.152f, 0.0f, 0.0f};
kernel void kernel_gauss_scale_transform(read_only image2d_t input, int in_offset_x, write_only image2d_t output_gauss

) {
  int g_x = get_global_id(0);
  int in_x = g_x + in_offset_x;
  int g_y = get_global_id(1) * 4;
  const sampler_t sampler = 0 | 2 | 0x10;

  int g_out_x = get_global_id(0);
  int g_out_y = get_global_id(1) * 2;
  float8 result_pre[2] = {(float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f), (float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f)};
  float8 result_next[2] = {(float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f), (float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f)};
  float8 result_cur[2] = {(float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f), (float8)(0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f)};
  float4 final_g[2];

  float8 tmp_data;
  int i_ver;

  for (i_ver = -2; i_ver <= 2 + 2; i_ver++) {
    int cur_g_y = g_y + i_ver;
    float coeff0 = coeffs[hook(3, i_ver + 4)];
    float coeff1 = coeffs[hook(3, i_ver + 4 - 2)];
    tmp_data = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(in_x - 1, cur_g_y)))), uchar8));
    result_pre[hook(4, 0)] += tmp_data * coeff0;
    result_pre[hook(4, 1)] += tmp_data * coeff1;
    tmp_data = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(in_x, cur_g_y)))), uchar8));
    result_cur[hook(5, 0)] += tmp_data * coeff0;
    result_cur[hook(5, 1)] += tmp_data * coeff1;
    tmp_data = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(in_x + 1, cur_g_y)))), uchar8));
    result_next[hook(6, 1)] += tmp_data * coeff1;
    result_next[hook(6, 0)] += tmp_data * coeff0;
  }

  int i_line;
  for (i_line = 0; i_line < 2; ++i_line) {
    final_g[hook(7, i_line)] = result_cur[hook(5, i_line)].even * coeffs[hook(3, 4)] + (float4)(result_pre[hook(4, i_line)].s7, result_cur[hook(5, i_line)].s135) * coeffs[hook(3, 4 + 1)] + (float4)(result_pre[hook(4, i_line)].s6, result_cur[hook(5, i_line)].s024) * coeffs[hook(3, 4 + 2)] + (float4)(result_cur[hook(5, i_line)].s1357) * coeffs[hook(3, 4 + 1)] + (float4)(result_cur[hook(5, i_line)].s246, result_next[hook(6, i_line)].s0) * coeffs[hook(3, 4 + 2)];

    final_g[hook(7, i_line)] = clamp(final_g[hook(7, i_line)] + 0.5f, 0.0f, 255.0f);
    write_imageui(output_gauss, (int2)(g_out_x, g_out_y + i_line), convert_uint4(final_g[hook(7, i_line)]));
  }
}