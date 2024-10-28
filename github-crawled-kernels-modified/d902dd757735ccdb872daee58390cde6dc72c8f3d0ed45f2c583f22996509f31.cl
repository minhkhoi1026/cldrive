//{"gain":0,"input":4,"inputPrev1":5,"inputPrev2":6,"observe_cache":8,"output":3,"ref_cache":7,"restore":9,"restoredPrev":2,"threshold":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void weighted_average(read_only image2d_t input, local float4* ref_cache, bool load_observe, local float4* observe_cache, float4* restore, float2* sum_weight, float gain, float threshold) {
  sampler_t sampler = 0 | 2 | 0x10;

  const int local_id_x = get_local_id(0);
  const int local_id_y = get_local_id(1);
  const int group_id_x = get_group_id(0);
  const int group_id_y = get_group_id(1);

  int i = local_id_x + local_id_y * 8;
  int start_x = mad24(group_id_x, 8, -1);
  int start_y = mad24(group_id_y, 8, -4);
  for (int j = i; j < (8 + 2 * 1) * (8 + 2 * 4); j += (8 * 1)) {
    int corrd_x = start_x + (j % (8 + 2 * 1));
    int corrd_y = start_y + (j / (8 + 2 * 1));
    ref_cache[hook(7, j)] = read_imagef(input, sampler, (int2)(corrd_x, corrd_y));
  }
  barrier(0x01);

  if (load_observe) {
    for (int i = 0; i < 8; i++) {
      observe_cache[hook(8, i * 8 + local_id_x)] = ref_cache[hook(7, (i + 4) * (8 + 2 * 1) + local_id_x + 1)];
    }
  }

  float4 dist = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 gradient = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float weight = 0.0f;

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      dist = (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))] - observe_cache[hook(8, local_id_x)]) * (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))] - observe_cache[hook(8, local_id_x)]);
      dist = mad((ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 8 + local_id_x)]), (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 8 + local_id_x)]), dist);
      dist = mad((ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 2 * 8 + local_id_x)]), (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 2 * 8 + local_id_x)]), dist);
      dist = mad((ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 3 * 8 + local_id_x)]), (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 3 * 8 + local_id_x)]), dist);

      gradient = (float4)(ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2);
      gradient = (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))]) + (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))]) + (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))]) + (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))]);
      gradient.s0 = (gradient.s0 + gradient.s1 + gradient.s2 + gradient.s3) / 15.0f;
      gain = (gradient.s0 < threshold) ? gain : 2.0f * gain;

      weight = native_exp(-gain * (dist.s0 + dist.s1 + dist.s2 + dist.s3));
      weight = (weight < 0) ? 0 : weight;
      (*sum_weight).s0 = (*sum_weight).s0 + weight;

      restore[hook(9, 0)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))], restore[hook(9, 0)]);
      restore[hook(9, 1)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))], restore[hook(9, 1)]);
      restore[hook(9, 2)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))], restore[hook(9, 2)]);
      restore[hook(9, 3)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))], restore[hook(9, 3)]);
    }
  }

  for (int i = 1; i < 4; i++) {
    for (int j = 0; j < 3; j++) {
      dist = (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))] - observe_cache[hook(8, 4 * 8 + local_id_x)]) * (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))] - observe_cache[hook(8, 4 * 8 + local_id_x)]);
      dist = mad((ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 5 * 8 + local_id_x)]), (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 5 * 8 + local_id_x)]), dist);
      dist = mad((ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 6 * 8 + local_id_x)]), (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 6 * 8 + local_id_x)]), dist);
      dist = mad((ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 7 * 8 + local_id_x)]), (ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))] - observe_cache[hook(8, 7 * 8 + local_id_x)]), dist);

      gradient = (float4)(ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))].s2);
      gradient = (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))]) + (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))]) + (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))]) + (gradient - ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))]);
      gradient.s0 = (gradient.s0 + gradient.s1 + gradient.s2 + gradient.s3) / 15.0f;
      gain = (gradient.s0 < threshold) ? gain : 2.0f * gain;

      weight = native_exp(-gain * (dist.s0 + dist.s1 + dist.s2 + dist.s3));
      weight = (weight < 0) ? 0 : weight;
      (*sum_weight).s1 = (*sum_weight).s1 + weight;

      restore[hook(9, 4)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), local_id_x + j))], restore[hook(9, 4)]);
      restore[hook(9, 5)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), (8 + 2 * 1) + local_id_x + j))], restore[hook(9, 5)]);
      restore[hook(9, 6)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 2 * (8 + 2 * 1) + local_id_x + j))], restore[hook(9, 6)]);
      restore[hook(9, 7)] = mad(weight, ref_cache[hook(7, mad24(i, 4 * (8 + 2 * 1), 3 * (8 + 2 * 1) + local_id_x + j))], restore[hook(9, 7)]);
    }
  }
}

kernel void kernel_3d_denoise_slm(float gain, float threshold, read_only image2d_t restoredPrev, write_only image2d_t output, read_only image2d_t input, read_only image2d_t inputPrev1, read_only image2d_t inputPrev2) {
  float4 restore[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
  float2 sum_weight = {0.0f, 0.0f};

  local float4 ref_cache[(8 + 2 * 4) * (8 + 2 * 1)];
  local float4 observe_cache[8 * 8];

  weighted_average(input, ref_cache, true, observe_cache, restore, &sum_weight, gain, threshold);

  weighted_average(restoredPrev, ref_cache, false, observe_cache, restore, &sum_weight, gain, threshold);
  restore[hook(9, 0)] = restore[hook(9, 0)] / sum_weight.s0;
  restore[hook(9, 1)] = restore[hook(9, 1)] / sum_weight.s0;
  restore[hook(9, 2)] = restore[hook(9, 2)] / sum_weight.s0;
  restore[hook(9, 3)] = restore[hook(9, 3)] / sum_weight.s0;

  restore[hook(9, 4)] = restore[hook(9, 4)] / sum_weight.s1;
  restore[hook(9, 5)] = restore[hook(9, 5)] / sum_weight.s1;
  restore[hook(9, 6)] = restore[hook(9, 6)] / sum_weight.s1;
  restore[hook(9, 7)] = restore[hook(9, 7)] / sum_weight.s1;

  const int global_id_x = get_global_id(0);
  const int global_id_y = get_global_id(1);

  write_imagef(output, (int2)(global_id_x, 8 * global_id_y), restore[hook(9, 0)]);
  write_imagef(output, (int2)(global_id_x, mad24(8, global_id_y, 1)), restore[hook(9, 1)]);
  write_imagef(output, (int2)(global_id_x, mad24(8, global_id_y, 2)), restore[hook(9, 2)]);
  write_imagef(output, (int2)(global_id_x, mad24(8, global_id_y, 3)), restore[hook(9, 3)]);
  write_imagef(output, (int2)(global_id_x, mad24(8, global_id_y, 4)), restore[hook(9, 4)]);
  write_imagef(output, (int2)(global_id_x, mad24(8, global_id_y, 5)), restore[hook(9, 5)]);
  write_imagef(output, (int2)(global_id_x, mad24(8, global_id_y, 6)), restore[hook(9, 6)]);
  write_imagef(output, (int2)(global_id_x, mad24(8, global_id_y, 7)), restore[hook(9, 7)]);
}