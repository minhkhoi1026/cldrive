//{"in_sampler_offset_x":1,"in_sampler_offset_y":2,"input_gauss":0,"input_lap":3,"out_height":7,"out_offset_x":5,"out_width":6,"output":4}
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

kernel void kernel_gauss_lap_reconstruct(read_only image2d_t input_gauss, float in_sampler_offset_x, float in_sampler_offset_y, read_only image2d_t input_lap, write_only image2d_t output, int out_offset_x, float out_width, float out_height

) {
  int g_x = get_global_id(0);
  int g_y = get_global_id(1);
  const sampler_t lap_sampler = 0 | 2 | 0x10;
  const sampler_t gauss_sampler = 1 | 2 | 0x20;

  float8 lap = convert_float8(__builtin_astype((convert_ushort4(read_imageui(input_lap, lap_sampler, (int2)(g_x, g_y)))), uchar8));
  lap = (lap - 128.0f) * 2.0f;

  float8 data_g;
  float2 input_gauss_pos;
  float step_x;
  input_gauss_pos.x = g_x / out_width + in_sampler_offset_x;
  input_gauss_pos.y = g_y / out_height + in_sampler_offset_y;

  step_x = 0.125f / out_width;
  data_g = read_scale_y(input_gauss, gauss_sampler, input_gauss_pos, step_x) * 256.0f;
  data_g += lap + 0.5f;
  data_g = clamp(data_g, 0.0f, 255.0f);
  write_imageui(output, (int2)(g_x + out_offset_x, g_y), convert_uint4(__builtin_astype((convert_uchar8(data_g)), ushort4)));
}