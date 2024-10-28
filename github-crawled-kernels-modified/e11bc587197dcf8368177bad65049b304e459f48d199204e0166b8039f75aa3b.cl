//{"image":0,"max_pos":5,"offset_x":3,"pos_buf":1,"seam_height":6,"seam_stride":7,"slm_sum":8,"sum_buf":2,"valid_width":4}
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

kernel void kernel_seam_dp(read_only image2d_t image, global short* pos_buf, global float* sum_buf, int offset_x, int valid_width, int max_pos, int seam_height, int seam_stride) {
  int l_x = get_local_id(0);
  int group_id = get_group_id(0);
  if (l_x >= valid_width)
    return;

  int first_slice_h = seam_height / 2;
  int group_h = (group_id == 0 ? first_slice_h : seam_height - first_slice_h);

  local float slm_sum[4096];
  float mid, left, right, cur;
  int slm_idx;
  int default_pos;

  int x = l_x + offset_x;
  const sampler_t sampler = 0 | 2 | 0x10;
  int y = (group_id == 0 ? 0 : seam_height - 1);
  float sum = convert_float(read_imageui(image, sampler, (int2)(x, y)).x);

  default_pos = x;
  slm_sum[hook(8, l_x)] = sum;
  barrier(0x01);
  pos_buf[hook(1, pos_buf_index(x, y, seam_stride))] = convert_short(default_pos);

  for (int i = 0; i < group_h; ++i) {
    y = (group_id == 0 ? i : seam_height - i - 1);
    slm_idx = l_x - 1;
    slm_idx = (slm_idx > 0 ? slm_idx : 0);
    left = slm_sum[hook(8, slm_idx)];
    slm_idx = l_x + 1;
    slm_idx = (slm_idx < valid_width ? slm_idx : valid_width - 1);
    right = slm_sum[hook(8, slm_idx)];

    cur = convert_float(read_imageui(image, sampler, (int2)(x, y)).x);

    left = left + cur;
    right = right + cur;
    mid = sum + cur;

    int pos;
    pos = (left < mid) ? (int)(-1) : (int)(0);
    sum = min(left, mid);
    pos = (sum < right) ? pos : (int)(1);
    sum = min(sum, right);
    slm_sum[hook(8, l_x)] = sum;
    barrier(0x01);

    pos += default_pos;
    pos = clamp(pos, offset_x, max_pos);

    pos_buf[hook(1, pos_buf_index(x, y, seam_stride))] = convert_short(pos);
  }
  sum_buf[hook(2, group_id * seam_stride + x)] = sum;
}