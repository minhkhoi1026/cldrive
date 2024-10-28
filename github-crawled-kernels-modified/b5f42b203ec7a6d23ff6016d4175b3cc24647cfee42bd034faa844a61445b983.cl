//{"input":0,"layer":2,"line_sum":4,"local_src_data":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_wavelet_coeff_variance(read_only image2d_t input, write_only image2d_t output, int layer) {
  sampler_t sampler = 0 | 2 | 0x10;

  int g_id_x = get_global_id(0);
  int g_id_y = get_global_id(1);

  int group_id_x = get_group_id(0);
  int group_id_y = get_group_id(1);

  int local_id_x = get_local_id(0);
  int local_id_y = get_local_id(1);

  int g_size_x = get_global_size(0);
  int g_size_y = get_global_size(1);

  int l_size_x = get_local_size(0);
  int l_size_y = get_local_size(1);

  int local_index = local_id_y * 8 + local_id_x;

  float offset = 0.5f;
  float4 line_sum[5] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
  float4 line_var = 0.0f;

  local float4 local_src_data[(8 + 1 * 2) * (8 + 2 * 2)];

  int i = local_id_x + local_id_y * 8;
  int start_x = mad24(group_id_x, 8, -1);
  int start_y = mad24(group_id_y, 8, -2);

  for (int j = i; j < (8 + 1 * 2) * (8 + 2 * 2); j += 8 * 8) {
    int x = start_x + (j % (8 + 1 * 2));
    int y = start_y + (j / (8 + 1 * 2));
    local_src_data[hook(3, j)] = read_imagef(input, sampler, (int2)(x, y)) - offset;
  }
  barrier(0x01);

  float16 line0 = *((local float16*)(local_src_data + local_id_y * (8 + 1 * 2) + local_id_x));
  float16 line1 = *((local float16*)(local_src_data + (local_id_y + 1) * (8 + 1 * 2) + local_id_x));
  float16 line2 = *((local float16*)(local_src_data + (local_id_y + 2) * (8 + 1 * 2) + local_id_x));
  float16 line3 = *((local float16*)(local_src_data + (local_id_y + 3) * (8 + 1 * 2) + local_id_x));
  float16 line4 = *((local float16*)(local_src_data + (local_id_y + 4) * (8 + 1 * 2) + local_id_x));

  line_sum[hook(4, 0)] = mad(line0.s0123, line0.s0123, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s1234, line0.s1234, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s2345, line0.s2345, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s3456, line0.s3456, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s4567, line0.s4567, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s5678, line0.s5678, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s6789, line0.s6789, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s789a, line0.s789a, line_sum[hook(4, 0)]);
  line_sum[hook(4, 0)] = mad(line0.s89ab, line0.s89ab, line_sum[hook(4, 0)]);

  line_sum[hook(4, 1)] = mad(line1.s0123, line1.s0123, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s1234, line1.s1234, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s2345, line1.s2345, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s3456, line1.s3456, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s4567, line1.s4567, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s5678, line1.s5678, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s6789, line1.s6789, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s789a, line1.s789a, line_sum[hook(4, 1)]);
  line_sum[hook(4, 1)] = mad(line1.s89ab, line1.s89ab, line_sum[hook(4, 1)]);

  line_sum[hook(4, 2)] = mad(line2.s0123, line2.s0123, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s1234, line2.s1234, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s2345, line2.s2345, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s3456, line2.s3456, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s4567, line2.s4567, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s5678, line2.s5678, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s6789, line2.s6789, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s789a, line2.s789a, line_sum[hook(4, 2)]);
  line_sum[hook(4, 2)] = mad(line2.s89ab, line2.s89ab, line_sum[hook(4, 2)]);

  line_sum[hook(4, 3)] = mad(line3.s0123, line3.s0123, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s1234, line3.s1234, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s2345, line3.s2345, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s3456, line3.s3456, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s4567, line3.s4567, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s5678, line3.s5678, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s6789, line3.s6789, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s789a, line3.s789a, line_sum[hook(4, 3)]);
  line_sum[hook(4, 3)] = mad(line3.s89ab, line3.s89ab, line_sum[hook(4, 3)]);

  line_sum[hook(4, 4)] = mad(line4.s0123, line4.s0123, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s1234, line4.s1234, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s2345, line4.s2345, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s3456, line4.s3456, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s4567, line4.s4567, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s5678, line4.s5678, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s6789, line4.s6789, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s789a, line4.s789a, line_sum[hook(4, 4)]);
  line_sum[hook(4, 4)] = mad(line4.s89ab, line4.s89ab, line_sum[hook(4, 4)]);

  line_var = (line_sum[hook(4, 0)] + line_sum[hook(4, 1)] + line_sum[hook(4, 2)] + line_sum[hook(4, 3)] + line_sum[hook(4, 4)]) / 45;
  write_imagef(output, (int2)(g_id_x, g_id_y), line_var);
}