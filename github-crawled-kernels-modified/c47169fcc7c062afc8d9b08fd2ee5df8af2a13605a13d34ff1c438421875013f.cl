//{"in_b":12,"in_g":11,"in_r":10,"input_b":7,"input_dark":0,"input_g":6,"input_r":5,"max_b":4,"max_g":3,"max_r":2,"max_v":1,"out_y":8,"output_uv":9,"transmit_map":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_defog_recover(read_only image2d_t input_dark, float max_v, float max_r, float max_g, float max_b, read_only image2d_t input_r, read_only image2d_t input_g, read_only image2d_t input_b, write_only image2d_t out_y, write_only image2d_t output_uv) {
  int g_id_x = get_global_id(0);
  int g_id_y = get_global_id(1);
  int pos_x = g_id_x;
  int pos_y = g_id_y * 2;
  sampler_t sampler = 0 | 2 | 0x10;
  float8 in_r[2], in_g[2], in_b[2];
  float8 transmit_map[2];
  float8 out_data;

  in_r[hook(10, 0)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_r, sampler, (int2)(pos_x, pos_y)))), uchar8));
  in_r[hook(10, 1)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_r, sampler, (int2)(pos_x, pos_y + 1)))), uchar8));
  in_g[hook(11, 0)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_g, sampler, (int2)(pos_x, pos_y)))), uchar8));
  in_g[hook(11, 1)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_g, sampler, (int2)(pos_x, pos_y + 1)))), uchar8));
  in_b[hook(12, 0)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_b, sampler, (int2)(pos_x, pos_y)))), uchar8));
  in_b[hook(12, 1)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_b, sampler, (int2)(pos_x, pos_y + 1)))), uchar8));
  transmit_map[hook(13, 0)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_dark, sampler, (int2)(pos_x, pos_y)))), uchar8));
  transmit_map[hook(13, 1)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_dark, sampler, (int2)(pos_x, pos_y + 1)))), uchar8));

  transmit_map[hook(13, 0)] = 1.0f - 0.95f * transmit_map[hook(13, 0)] / max_v;
  transmit_map[hook(13, 1)] = 1.0f - 0.95f * transmit_map[hook(13, 1)] / max_v;

  transmit_map[hook(13, 0)] = max(transmit_map[hook(13, 0)], 0.1f);
  transmit_map[hook(13, 1)] = max(transmit_map[hook(13, 1)], 0.1f);

  float8 gain = 2.0f;
  in_r[hook(10, 0)] = (max_r + (in_r[hook(10, 0)] - max_r) / transmit_map[hook(13, 0)]) * gain;
  in_r[hook(10, 1)] = (max_r + (in_r[hook(10, 1)] - max_r) / transmit_map[hook(13, 1)]) * gain;
  in_g[hook(11, 0)] = (max_g + (in_g[hook(11, 0)] - max_g) / transmit_map[hook(13, 0)]) * gain;
  in_g[hook(11, 1)] = (max_g + (in_g[hook(11, 1)] - max_g) / transmit_map[hook(13, 1)]) * gain;
  in_b[hook(12, 0)] = (max_b + (in_b[hook(12, 0)] - max_b) / transmit_map[hook(13, 0)]) * gain;
  in_b[hook(12, 1)] = (max_b + (in_b[hook(12, 1)] - max_b) / transmit_map[hook(13, 1)]) * gain;

  out_data = 0.299f * in_r[hook(10, 0)] + 0.587f * in_g[hook(11, 0)] + 0.114f * in_b[hook(12, 0)];
  out_data = clamp(out_data, 0.0f, 255.0f);
  write_imageui(out_y, (int2)(pos_x, pos_y), convert_uint4(__builtin_astype((convert_uchar8(out_data)), ushort4)));
  out_data = 0.299f * in_r[hook(10, 1)] + 0.587f * in_g[hook(11, 1)] + 0.114f * in_b[hook(12, 1)];
  out_data = clamp(out_data, 0.0f, 255.0f);
  write_imageui(out_y, (int2)(pos_x, pos_y + 1), convert_uint4(__builtin_astype((convert_uchar8(out_data)), ushort4)));

  float4 r, g, b;
  r = (in_r[hook(10, 0)].even + in_r[hook(10, 0)].odd + in_r[hook(10, 1)].even + in_r[hook(10, 1)].odd) * 0.25f;
  g = (in_g[hook(11, 0)].even + in_g[hook(11, 0)].odd + in_g[hook(11, 1)].even + in_g[hook(11, 1)].odd) * 0.25f;
  b = (in_b[hook(12, 0)].even + in_b[hook(12, 0)].odd + in_b[hook(12, 1)].even + in_b[hook(12, 1)].odd) * 0.25f;
  out_data.even = (-0.169f * r - 0.331f * g + 0.5f * b) + 128.0f;
  out_data.odd = (0.5f * r - 0.419f * g - 0.081f * b) + 128.0f;
  out_data = clamp(out_data, 0.0f, 255.0f);
  write_imageui(output_uv, (int2)(g_id_x, g_id_y), convert_uint4(__builtin_astype((convert_uchar8(out_data)), ushort4)));
}