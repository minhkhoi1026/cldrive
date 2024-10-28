//{"input0":0,"input1":2,"offset0":1,"offset1":3,"out_diff":4}
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

kernel void kernel_image_diff(read_only image2d_t input0, int offset0, read_only image2d_t input1, int offset1, write_only image2d_t out_diff) {
  int g_x = get_global_id(0);
  int g_y = get_global_id(1);
  const sampler_t sampler = 0 | 2 | 0x10;

  int8 data0 = convert_int8(__builtin_astype((convert_ushort4(read_imageui(input0, sampler, (int2)(g_x + offset0, g_y)))), uchar8));
  int8 data1 = convert_int8(__builtin_astype((convert_ushort4(read_imageui(input1, sampler, (int2)(g_x + offset1, g_y)))), uchar8));
  uint8 diff = abs_diff(data0, data1);
  write_imageui(out_diff, (int2)(g_x, g_y), convert_uint4(__builtin_astype((convert_uchar8(diff)), ushort4)));
}