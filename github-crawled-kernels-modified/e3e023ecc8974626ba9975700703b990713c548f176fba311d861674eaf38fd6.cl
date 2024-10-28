//{"input0":0,"input1":1,"output":3,"seam_mask":2}
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

kernel void kernel_seam_mask_blend(read_only image2d_t input0, read_only image2d_t input1, read_only image2d_t seam_mask, write_only image2d_t output) {
  sampler_t sampler = 0 | 2 | 0x10;
  const int g_x = get_global_id(0);
  const int g_y = get_global_id(1);
  int2 pos = (int2)(g_x, g_y);

  float8 data0 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input0, sampler, pos))), uchar8));
  float8 data1 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input1, sampler, pos))), uchar8));
  float8 coeff0 = convert_float8(__builtin_astype((convert_ushort4(read_imageui(seam_mask, sampler, pos))), uchar8)) / 255.0f;
  float8 out_data;

  out_data = (data0 - data1) * coeff0 + data1;

  out_data = clamp(out_data + 0.5f, 0.0f, 255.0f);

  write_imageui(output, pos, convert_uint4(__builtin_astype((convert_uchar8(out_data)), ushort4)));
}