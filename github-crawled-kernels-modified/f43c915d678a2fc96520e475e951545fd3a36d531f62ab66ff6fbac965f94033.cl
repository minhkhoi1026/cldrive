//{"a":8,"addition_array":12,"b":9,"base_pos":7,"c":10,"data_extent":4,"misc_int":5,"oct_brick":3,"oct_index":2,"pool":0,"pool_sampler":1,"result":6,"samples_abc":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integrateLine(read_only image3d_t pool, sampler_t pool_sampler, global unsigned int* oct_index, global unsigned int* oct_brick, constant float* data_extent, constant int* misc_int, global float* result, float3 base_pos, float3 a, float3 b, float3 c, int3 samples_abc, local float* addition_array) {
  int2 id_loc = (int2)(get_local_id(0), get_local_id(1));
  int2 problem_size = (int2)(samples_abc.z, samples_abc.x * samples_abc.y);

  if (id_loc.y == 0) {
    result[hook(6, get_global_id(0))] = 0;
  }

  for (int iter = 0; iter < (problem_size.y / get_local_size(1) + 1); iter++) {
    int2 problem_id = (int2)(get_global_id(0), get_local_size(1) * iter + id_loc.y);

    if ((problem_id.x < problem_size.x) && (problem_id.y < problem_size.y)) {
      int4 pool_dim = get_image_dim(pool);

      int n_tree_levels = misc_int[hook(5, 0)];
      int brick_dim = misc_int[hook(5, 1)];

      unsigned int index, brick, isMsd, isEmpty;
      float3 norm_pos;
      float4 lookup_pos;
      uint4 brick_id;
      int3 norm_index;

      unsigned int mask_msd_flag = ((1u << 1u) - 1u) << 31u;
      unsigned int mask_data_flag = ((1 << 1) - 1) << 30;
      unsigned int mask_child_index = ((1 << 30) - 1) << 0;
      unsigned int mask_brick_id_x = ((1 << 10) - 1) << 20;
      unsigned int mask_brick_id_y = ((1 << 10) - 1) << 10;
      unsigned int mask_brick_id_z = ((1 << 10) - 1) << 0;

      int i_a = problem_id.y % samples_abc.x;
      int i_b = problem_id.y / samples_abc.x;
      int i_c = problem_id.x;

      float3 pos = base_pos + (float3)(a.x * ((float)i_a) + b.x * ((float)i_b) + c.x * ((float)i_c), a.y * ((float)i_a) + b.y * ((float)i_b) + c.y * ((float)i_c), a.z * ((float)i_a) + b.z * ((float)i_b) + c.z * ((float)i_c));

      index = 0;

      norm_pos = native_divide((float3)(pos.x - data_extent[hook(4, 0)], pos.y - data_extent[hook(4, 2)], pos.z - data_extent[hook(4, 4)]), (float3)(data_extent[hook(4, 1)] - data_extent[hook(4, 0)], data_extent[hook(4, 3)] - data_extent[hook(4, 2)], data_extent[hook(4, 5)] - data_extent[hook(4, 4)])) * 2.0f;

      norm_index = convert_int3(norm_pos);
      norm_index = clamp(norm_index, 0, 1);

      for (int j = 0; j < n_tree_levels; j++) {
        brick = oct_index[hook(2, index)];
        isMsd = (brick & mask_msd_flag) >> 31;
        isEmpty = !((brick & mask_data_flag) >> 30);

        if (isMsd) {
          if (isEmpty) {
            addition_array[hook(12, id_loc.y)] = 0;
          } else {
            brick = oct_brick[hook(3, index)];
            brick_id = (uint4)((brick & mask_brick_id_x) >> 20, (brick & mask_brick_id_y) >> 10, brick & mask_brick_id_z, 0);

            lookup_pos = native_divide(0.5f + convert_float4(brick_id * brick_dim) + (float4)(norm_pos, 0.0f) * 3.5f, convert_float4(pool_dim));

            addition_array[hook(12, id_loc.y)] = read_imagef(pool, pool_sampler, lookup_pos).w;
          }

          break;
        } else {
          index = (brick & mask_child_index);
          index += norm_index.x + norm_index.y * 2 + norm_index.z * 4;

          norm_pos = (norm_pos - (float3)((float)norm_index.x, (float)norm_index.y, (float)norm_index.z)) * 2.0f;
          norm_index = convert_int3(norm_pos);
          norm_index = clamp(norm_index, 0, 1);
        }
      }
    } else {
      addition_array[hook(12, id_loc.y)] = 0;
    }

    barrier(0x01);

    for (unsigned int i = get_local_size(1) / 2; i > 0; i >>= 1) {
      if (get_local_id(1) < i) {
        addition_array[hook(12, get_local_id(1))] += addition_array[hook(12, i + get_local_id(1))];
      }

      barrier(0x01);
    }

    if (id_loc.y == 0) {
      result[hook(6, problem_id.x)] += addition_array[hook(12, 0)];
    }
  }
}