//{"gaussian_table":6,"image_height":4,"input":0,"local_src_data":5,"output":1,"y_max":2,"y_target":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tonemapping(read_only image2d_t input, write_only image2d_t output, float y_max, float y_target, int image_height) {
  int g_id_x = get_global_id(0);
  int g_id_y = get_global_id(1);

  int group_id_x = get_group_id(0);
  int group_id_y = get_group_id(1);

  int local_id_x = get_local_id(0);
  int local_id_y = get_local_id(1);

  int g_size_x = get_global_size(0);
  int g_size_y = get_global_size(1);

  sampler_t sampler = 0 | 2 | 0x10;

  float4 src_data_R = read_imagef(input, sampler, (int2)(g_id_x, g_id_y));
  float4 src_data_G = read_imagef(input, sampler, (int2)(g_id_x, g_id_y + image_height));
  float4 src_data_B = read_imagef(input, sampler, (int2)(g_id_x, g_id_y + image_height * 2));

  float4 src_y_data = src_data_R * 255.f * 0.299f + src_data_G * 255.f * 0.587f + src_data_B * 255.f * 0.114f;

  float gaussian_table[9] = {0.075f, 0.124f, 0.075f, 0.124f, 0.204f, 0.124f, 0.075f, 0.124f, 0.075f};
  float4 src_ym_data = 0.0f;

  local float4 local_src_data[10 * 10];

  int start_x = 8 * group_id_x - 1;
  int start_y = 8 * group_id_y - 1;
  int local_index = local_id_y * 8 + local_id_x;
  int offset_x = local_index % 10;
  int offset_y = local_index / 10;

  float4 data_R = read_imagef(input, sampler, (int2)(start_x + offset_x, start_y + offset_y));
  float4 data_G = read_imagef(input, sampler, (int2)(start_x + offset_x, start_y + offset_y + image_height));
  float4 data_B = read_imagef(input, sampler, (int2)(start_x + offset_x, start_y + offset_y + image_height * 2));
  local_src_data[hook(5, offset_y * 10 + offset_x)] = data_R * 255.f * 0.299f + data_G * 255.f * 0.587f + data_B * 255.f * 0.114f;

  if (local_index < 10 * 10 - 8 * 8) {
    offset_x = (local_index + 8 * 8) % 10;
    offset_y = (local_index + 8 * 8) / 10;

    data_R = read_imagef(input, sampler, (int2)(start_x + offset_x, start_y + offset_y));
    data_G = read_imagef(input, sampler, (int2)(start_x + offset_x, start_y + offset_y + image_height));
    data_B = read_imagef(input, sampler, (int2)(start_x + offset_x, start_y + offset_y + image_height * 2));
    local_src_data[hook(5, offset_y * 10 + offset_x)] = data_R * 255.f * 0.299f + data_G * 255.f * 0.587f + data_B * 255.f * 0.114f;
  }

  barrier(0x01);

  float4 y_data;
  float4 top_Y, bottom_Y;

  top_Y = local_src_data[hook(5, local_id_y * 10 + local_id_x + 1)];
  bottom_Y = local_src_data[hook(5, (local_id_y + 2) * 10 + local_id_x + 1)];

  y_data.x = local_src_data[hook(5, local_id_y * 10 + local_id_x)].w;
  y_data.yzw = top_Y.xyz;
  src_ym_data += y_data * (float4)gaussian_table[hook(6, 0)];

  src_ym_data += top_Y * (float4)gaussian_table[hook(6, 1)];

  y_data.xyz = top_Y.yzw;
  y_data.w = local_src_data[hook(5, local_id_y * 10 + local_id_x + 2)].x;
  src_ym_data += y_data * (float4)gaussian_table[hook(6, 2)];

  y_data.x = local_src_data[hook(5, (local_id_y + 1) * 10 + local_id_x)].w;
  y_data.yzw = src_y_data.xyz;
  src_ym_data += y_data * (float4)gaussian_table[hook(6, 3)];

  src_ym_data += src_y_data * (float4)gaussian_table[hook(6, 4)];

  y_data.xyz = src_y_data.yzw;
  y_data.w = local_src_data[hook(5, (local_id_y + 1) * 10 + local_id_x + 2)].x;
  src_ym_data += y_data * (float4)gaussian_table[hook(6, 5)];

  y_data.x = local_src_data[hook(5, (local_id_y + 2) * 10 + local_id_x)].w;
  y_data.yzw = bottom_Y.xyz;
  src_ym_data += y_data * (float4)gaussian_table[hook(6, 6)];

  src_ym_data += bottom_Y * (float4)gaussian_table[hook(6, 7)];

  y_data.xyz = bottom_Y.yzw;
  y_data.w = local_src_data[hook(5, (local_id_y + 2) * 10 + local_id_x + 2)].x;
  src_ym_data += y_data * (float4)gaussian_table[hook(6, 8)];
  float4 gain = ((float4)y_max + src_ym_data + (float4)y_target) / (src_y_data + src_ym_data + (float4)y_target);
  src_data_R = src_data_R * gain;
  src_data_G = src_data_G * gain;
  src_data_B = src_data_B * gain;

  write_imagef(output, (int2)(g_id_x, g_id_y), src_data_R);
  write_imagef(output, (int2)(g_id_x, g_id_y + image_height), src_data_G);
  write_imagef(output, (int2)(g_id_x, g_id_y + image_height * 2), src_data_B);
}