//{"((__local uchar8 *)data_center)":4,"data_center":3,"input":0,"output":1,"slm":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int uchar8_offset = 8 / 8;
void load_to_slm(read_only image2d_t input, local uchar8* slm, int group_start_x, int group_start_y) {
  sampler_t sampler = 0 | 2 | 0x10;
  int local_x = get_local_id(0);
  int local_y = get_local_id(1);
  int local_index = local_y * get_local_size(0) + local_x;

  int group_offset_x = group_start_x - uchar8_offset;
  int group_offset_y = group_start_y - 0;

  for (; local_index < ((128 + 8 * 2) / 8) * (4 + 0 * 2); local_index += get_local_size(0) * get_local_size(1)) {
    int slm_x = local_index % ((128 + 8 * 2) / 8);
    int slm_y = local_index / ((128 + 8 * 2) / 8);
    int pos_x = group_offset_x + slm_x;
    int pos_y = group_offset_y + slm_y;
    uchar8 data = __builtin_astype((convert_ushort4(read_imageui(input, sampler, (int2)(pos_x, pos_y)))), uchar8);
    slm[hook(2, local_index)] = data;
  }
}

void finish_vertical_min(local uchar8* data_center, write_only image2d_t output, int group_start_x, int group_start_y, int local_x, int local_y) {
  int pos_x, pos_y;
  uchar8 min_val = data_center[hook(3, 0)];
  int v;

  for (v = 1; v < 0; ++v) {
    min_val = min(min_val, data_center[hook(3, ((128 + 8 * 2) / 8) * v)]);
    min_val = min(min_val, data_center[hook(3, -((128 + 8 * 2) / 8) * v)]);
  }
  min_val = min(min_val, data_center[hook(3, ((128 + 8 * 2) / 8) * 0)]);

  uchar8 min_val_1 = min(min_val, data_center[hook(3, -((128 + 8 * 2) / 8) * 0)]);
  uchar8 min_val_2 = min(min_val, data_center[hook(3, ((128 + 8 * 2) / 8) * (0 + 1))]);

  pos_x = group_start_x + local_x;
  pos_y = group_start_y + local_y;

  write_imageui(output, (int2)(pos_x, pos_y), convert_uint4(__builtin_astype((min_val_1), ushort4)));
  write_imageui(output, (int2)(pos_x, pos_y + 1), convert_uint4(__builtin_astype((min_val_2), ushort4)));
}

void finish_horizontal_min(local uchar8* data_center, write_only image2d_t output, int group_start_x, int group_start_y, int local_x, int local_y) {
  uchar8 value = data_center[hook(3, 0)];
  uchar8 v_left = ((local uchar8*)data_center)[hook(4, -1)];
  uchar8 v_right = ((local uchar8*)data_center)[hook(4, 1)];
  uchar4 tmp4;
  uchar2 tmp2;
  uchar tmp1_left, tmp1_right;

  uchar shared_common;
  uchar first_common_min, second_common_min;
  uchar8 out_data;

  tmp4 = min(value.lo, value.hi);
  tmp2 = min(tmp4.s01, tmp4.s23);
  shared_common = min(tmp2.s0, tmp2.s1);
  shared_common = min(shared_common, v_left.s7);
  shared_common = min(shared_common, v_right.s0);

  tmp2 = min(v_left.s34, v_left.s56);
  first_common_min = min(tmp2.s0, tmp2.s1);
  first_common_min = min(first_common_min, shared_common);

  tmp2 = min(v_right.s12, v_right.s34);
  second_common_min = min(tmp2.s0, tmp2.s1);
  second_common_min = min(second_common_min, shared_common);

  tmp1_left = min(v_left.s1, v_left.s2);
  tmp1_right = min(v_right.s1, v_right.s2);
  out_data.s0 = min(tmp1_left, v_left.s0);
  out_data.s0 = min(out_data.s0, first_common_min);

  out_data.s1 = min(tmp1_left, first_common_min);
  out_data.s1 = min(out_data.s1, v_right.s1);

  out_data.s2 = min(v_left.s2, first_common_min);
  out_data.s2 = min(out_data.s2, tmp1_right);

  out_data.s3 = min(first_common_min, tmp1_right);
  out_data.s3 = min(out_data.s3, v_right.s3);

  tmp1_left = min(v_left.s5, v_left.s6);
  tmp1_right = min(v_right.s5, v_right.s6);
  out_data.s4 = min(tmp1_left, v_left.s4);
  out_data.s4 = min(out_data.s4, second_common_min);

  out_data.s5 = min(tmp1_left, second_common_min);
  out_data.s5 = min(out_data.s5, v_right.s5);

  out_data.s6 = min(v_left.s6, second_common_min);
  out_data.s6 = min(out_data.s6, tmp1_right);

  out_data.s7 = min(second_common_min, tmp1_right);
  out_data.s7 = min(out_data.s7, v_right.s7);

  int pos_x = group_start_x + local_x;
  int pos_y = group_start_y + local_y;

  write_imageui(output, (int2)(pos_x, pos_y), convert_uint4(__builtin_astype((out_data), ushort4)));
}

kernel void kernel_min_filter(read_only image2d_t input, write_only image2d_t output) {
  int group_start_x = get_group_id(0) * (128 / 8);
  int group_start_y = get_group_id(1) * 4;

  local uchar8 slm_cache[((128 + 8 * 2) / 8) * (4 + 0 * 2)];

  load_to_slm(input, slm_cache, group_start_x, group_start_y);
  barrier(0x01);

  int local_x = get_local_id(0);
  int local_y = get_local_id(1) * 1;
  int slm_x = local_x + uchar8_offset;
  int slm_y = local_y + 0;
  int slm_index = slm_x + slm_y * ((128 + 8 * 2) / 8);
  local uchar8* data_center = slm_cache + slm_index;

  finish_horizontal_min(data_center, output, group_start_x, group_start_y, local_x, local_y);
}