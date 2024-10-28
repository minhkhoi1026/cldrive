//{"input":0,"out_offset_x":2,"output":1,"output_height":4,"output_width":3}
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

kernel void kernel_pyramid_scale(read_only image2d_t input, write_only image2d_t output, int out_offset_x, int output_width, int output_height) {
  const sampler_t sampler = 1 | 2 | 0x20;
  int g_x = get_global_id(0);
  int g_y = get_global_id(1);

  float2 normCoor = (float2)(g_x, g_y) / (float2)(output_width, output_height);
  float8 out_data;
  float step_x;

  step_x = 0.125f / output_width;
  out_data = read_scale_y(input, sampler, normCoor, step_x) * 255.0f;

  out_data = clamp(out_data + 0.5f, 0.0f, 255.0f);
  write_imageui(output, (int2)(g_x + out_offset_x, g_y), convert_uint4(__builtin_astype((convert_uchar8(out_data)), ushort4)));
}