//{"hist_leq":4,"image_height":6,"image_width":5,"input":0,"output":1,"y_avg":3,"y_max":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_newtonemapping(read_only image2d_t input, write_only image2d_t output, global float* y_max, global float* y_avg, global float* hist_leq, int image_width, int image_height) {
  int g_id_x = get_global_id(0);
  int g_id_y = get_global_id(1);

  int group_id_x = get_group_id(0);
  int group_id_y = get_group_id(1);

  int local_id_x = get_local_id(0);
  int local_id_y = get_local_id(1);

  int g_size_x = get_global_size(0);
  int g_size_y = get_global_size(1);

  int local_index = local_id_y * 8 + local_id_x;
  int row_per_block = image_height / 4;
  int col_per_block = image_width / 4;
  int row_block_id = g_id_y / row_per_block;
  int col_block_id = g_id_x * 4 / col_per_block;

  sampler_t sampler = 0 | 2 | 0x10;

  float4 src_data_Gr = read_imagef(input, sampler, (int2)(g_id_x, g_id_y));
  float4 src_data_R = read_imagef(input, sampler, (int2)(g_id_x, g_id_y + image_height));
  float4 src_data_B = read_imagef(input, sampler, (int2)(g_id_x, g_id_y + image_height * 2));
  float4 src_data_Gb = read_imagef(input, sampler, (int2)(g_id_x, g_id_y + image_height * 3));

  float4 src_data_G = (src_data_Gr + src_data_Gb) / 2;

  float4 src_y_data = 0.0f;
  src_y_data = mad(src_data_R, 0.299f, src_y_data);
  src_y_data = mad(src_data_G, 0.587f, src_y_data);
  src_y_data = mad(src_data_B, 0.114f, src_y_data);

  float4 dst_y_data;
  float4 d, wd, haleq, s, ws;
  float4 total_w = 0.0f;
  float4 total_haleq = 0.0f;

  float4 corrd_x = mad((float4)g_id_x, 4.0f, (float4)(0.0f, 1.0f, 2.0f, 3.0f));
  float4 src_y = mad(src_y_data, 65535.0f, 0.5f) / 16.0f;

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      int center_x = mad24(col_per_block, j, col_per_block / 2);
      int center_y = mad24(row_per_block, i, row_per_block / 2);
      int start_index = mad24(i, 4, j) * 4096;

      float4 dy = (float4)((g_id_y - center_y) * (g_id_y - center_y));
      float4 dx = corrd_x - (float4)center_x;

      d = mad(dx, dx, dy);

      d = sqrt(d) + 100.0f;

      s = fabs(src_y_data - (float4)y_avg[hook(3, mad24(i, 4, j))]) / (float4)y_max[hook(2, mad24(i, 4, j))] + 1.0f;

      float4 w = 100.0f / (d * s);

      haleq.x = hist_leq[hook(4, start_index + (int)src_y.x)];
      haleq.y = hist_leq[hook(4, start_index + (int)src_y.y)];
      haleq.z = hist_leq[hook(4, start_index + (int)src_y.z)];
      haleq.w = hist_leq[hook(4, start_index + (int)src_y.w)];

      total_w = total_w + w;
      total_haleq = mad(haleq, w, total_haleq);
    }
  }

  dst_y_data = total_haleq / total_w;

  float4 gain = (dst_y_data + 0.0001f) / (src_y_data + 0.0001f);
  src_data_Gr = src_data_Gr * gain;
  src_data_R = src_data_R * gain;
  src_data_B = src_data_B * gain;
  src_data_Gb = src_data_Gb * gain;

  write_imagef(output, (int2)(g_id_x, g_id_y), src_data_Gr);
  write_imagef(output, (int2)(g_id_x, g_id_y + image_height), src_data_R);
  write_imagef(output, (int2)(g_id_x, g_id_y + image_height * 2), src_data_B);
  write_imagef(output, (int2)(g_id_x, g_id_y + image_height * 3), src_data_Gb);
}