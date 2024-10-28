//{"geo_table":2,"input_pos":8,"input_uv":1,"input_y":0,"lsc_ptr":10,"out_of_bound":7,"out_size":6,"output_data":9,"output_uv":5,"output_y":4,"table_scale_size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void get_geo_mapped_y(read_only image2d_t input, read_only image2d_t geo_table, float2 table_pos, float step_x, bool* out_of_bound, float2* input_pos, float8* out_y) {
  sampler_t sampler = 1 | 2 | 0x20;
  float* output_data = (float*)(out_y);
  int i = 0;

  for (i = 0; i < 8; ++i) {
    out_of_bound[hook(7, i)] = (min(table_pos.x, table_pos.y) < 0.0f) || (max(table_pos.x, table_pos.y) > 1.0f);
    input_pos[hook(8, i)] = read_imagef(geo_table, sampler, table_pos).xy;

    output_data[hook(9, i)] = out_of_bound[hook(7, i)] ? 0.0f : read_imagef(input, sampler, input_pos[hook(8, i)]).x;
    table_pos.x += step_x;
  }
}

void get_lsc_data(image2d_t lsc_table, int2 g_pos, float step_x, float2 gray_threshold, float8 output, float8* lsc_data) {
  sampler_t sampler = 1 | 2 | 0x20;
  float* lsc_ptr = (float*)(lsc_data);

  float2 pos = convert_float2((int2)(g_pos.x * 8, g_pos.y)) * step_x;
  for (int i = 0; i < 8; ++i) {
    lsc_ptr[hook(10, i)] = read_imagef(lsc_table, sampler, pos).x;
    pos.x += step_x;
  }

  float8 diff_ratio = (gray_threshold.y - output * 255.0f) / (gray_threshold.y - gray_threshold.x);
  diff_ratio = clamp(diff_ratio, 0.0f, 1.0f);
  (*lsc_data) = diff_ratio * diff_ratio * ((*lsc_data) - 1.0f) + 1.0f;
}

kernel void kernel_geo_map(read_only image2d_t input_y, read_only image2d_t input_uv, read_only image2d_t geo_table, float2 table_scale_size,

                           write_only image2d_t output_y, write_only image2d_t output_uv, float2 out_size) {
  const int g_x = get_global_id(0);
  const int g_y_uv = get_global_id(1);
  const int g_y = get_global_id(1) * 2;
  float8 output_data;
  float2 from_pos;
  bool out_of_bound[8];
  float2 input_pos[8];

  float2 table_scale_step = 1.0f / table_scale_size;
  float2 out_map_pos;
  sampler_t sampler = 1 | 2 | 0x20;

  out_map_pos = (convert_float2((int2)(g_x * 8, g_y)) - out_size / 2.0f) * table_scale_step + 0.5f;

  get_geo_mapped_y(input_y, geo_table, out_map_pos, table_scale_step.x, out_of_bound, input_pos, &output_data);

  write_imageui(output_y, (int2)(g_x, g_y), convert_uint4(__builtin_astype((convert_uchar8(output_data * 255.0f)), ushort4)));

  output_data.s01 = out_of_bound[hook(7, 0)] ? (float2)(0.5f, 0.5f) : read_imagef(input_uv, sampler, input_pos[hook(8, 0)]).xy;
  output_data.s23 = out_of_bound[hook(7, 2)] ? (float2)(0.5f, 0.5f) : read_imagef(input_uv, sampler, input_pos[hook(8, 2)]).xy;
  output_data.s45 = out_of_bound[hook(7, 4)] ? (float2)(0.5f, 0.5f) : read_imagef(input_uv, sampler, input_pos[hook(8, 4)]).xy;
  output_data.s67 = out_of_bound[hook(7, 6)] ? (float2)(0.5f, 0.5f) : read_imagef(input_uv, sampler, input_pos[hook(8, 6)]).xy;
  write_imageui(output_uv, (int2)(g_x, g_y_uv), convert_uint4(__builtin_astype((convert_uchar8(output_data * 255.0f)), ushort4)));

  out_map_pos.y += table_scale_step.y;
  get_geo_mapped_y(input_y, geo_table, out_map_pos, table_scale_step.x, out_of_bound, input_pos, &output_data);

  write_imageui(output_y, (int2)(g_x, g_y + 1), convert_uint4(__builtin_astype((convert_uchar8(output_data * 255.0f)), ushort4)));
}