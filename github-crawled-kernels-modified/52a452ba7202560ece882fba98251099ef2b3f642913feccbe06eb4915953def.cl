//{"input_uv":1,"input_y":0,"out_dark_channel":2,"output_b":5,"output_g":4,"output_r":3,"y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_dark_channel(read_only image2d_t input_y, read_only image2d_t input_uv, write_only image2d_t out_dark_channel, write_only image2d_t output_r, write_only image2d_t output_g, write_only image2d_t output_b) {
  int pos_x = get_global_id(0);
  int pos_y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;
  float8 y[2];
  float8 r, g, b;
  float8 uv_r, uv_g, uv_b;
  uint4 ret;
  int2 pos;

  y[hook(6, 0)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_y, sampler, (int2)(pos_x, pos_y * 2)))), uchar8));
  y[hook(6, 1)] = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_y, sampler, (int2)(pos_x, pos_y * 2 + 1)))), uchar8));
  float8 uv = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_uv, sampler, (int2)(pos_x, pos_y)))), uchar8)) - 128.0f;

  uv_r.even = -0.001f * uv.even + 1.402f * uv.odd;
  uv_r.odd = uv_r.even;
  uv_g.even = -0.344f * uv.even - 0.714f * uv.odd;
  uv_g.odd = uv_g.even;
  uv_b.even = 1.772f * uv.even + 0.001f * uv.odd;
  uv_b.odd = uv_b.even;

  for (int i = 0; i < 2; ++i) {
    r = y[hook(6, i)] + uv_r;
    g = y[hook(6, i)] + uv_g;
    b = y[hook(6, i)] + uv_b;
    r = clamp(r, 0.0f, 255.0f);
    g = clamp(g, 0.0f, 255.0f);
    b = clamp(b, 0.0f, 255.0f);

    pos = (int2)(pos_x, 2 * pos_y + i);

    ret = convert_uint4(__builtin_astype((convert_uchar8(r)), ushort4));
    write_imageui(output_r, pos, ret);
    ret = convert_uint4(__builtin_astype((convert_uchar8(g)), ushort4));
    write_imageui(output_g, pos, ret);
    ret = convert_uint4(__builtin_astype((convert_uchar8(b)), ushort4));
    write_imageui(output_b, pos, ret);

    r = min(r, g);
    r = min(r, b);
    ret = convert_uint4(__builtin_astype((convert_uchar8(r)), ushort4));
    write_imageui(out_dark_channel, pos, ret);
  }
}