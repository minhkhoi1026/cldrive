//{"gauss0_offset_x":1,"gauss1_sampler_offset_x":3,"gauss1_sampler_offset_y":4,"input_gauss0":0,"input_gauss1":2,"lap_offset_x":6,"out_height":8,"out_width":7,"output":5}
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

kernel void kernel_lap_transform(read_only image2d_t input_gauss0, int gauss0_offset_x, read_only image2d_t input_gauss1, float gauss1_sampler_offset_x, float gauss1_sampler_offset_y, write_only image2d_t output, int lap_offset_x, float out_width, float out_height) {
  int g_x = get_global_id(0);
  int g_y = get_global_id(1);
  const sampler_t gauss0_sampler = 0 | 2 | 0x10;
  const sampler_t gauss1_sampler = 1 | 2 | 0x20;

  float8 orig = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_gauss0, gauss0_sampler, (int2)(g_x + gauss0_offset_x, g_y)))), uchar8));
  float8 zoom_in;
  float2 gauss1_pos;
  float sampler_step;
  gauss1_pos.y = (g_y / out_height) + gauss1_sampler_offset_y;
  gauss1_pos.x = (g_x / out_width) + gauss1_sampler_offset_x;

  sampler_step = 0.125f / out_width;
  zoom_in.s0 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  gauss1_pos.x += sampler_step;
  zoom_in.s1 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  gauss1_pos.x += sampler_step;
  zoom_in.s2 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  gauss1_pos.x += sampler_step;
  zoom_in.s3 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  gauss1_pos.x += sampler_step;
  zoom_in.s4 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  gauss1_pos.x += sampler_step;
  zoom_in.s5 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  gauss1_pos.x += sampler_step;
  zoom_in.s6 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  gauss1_pos.x += sampler_step;
  zoom_in.s7 = read_imagef(input_gauss1, gauss1_sampler, gauss1_pos).x;
  float8 lap = (orig - zoom_in * 256.0f) * 0.5f + 128.0f + 0.5f;
  lap = clamp(lap, 0.0f, 255.0f);
  write_imageui(output, (int2)(g_x + lap_offset_x, g_y), convert_uint4(__builtin_astype((convert_uchar8(lap)), ushort4)));
}