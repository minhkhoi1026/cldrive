//{"a":8,"addition_array":12,"b":9,"base_pos":7,"c":10,"data_extent":4,"misc_int":5,"oct_brick":3,"oct_index":2,"pool":0,"pool_sampler":1,"result":6,"samples_abc":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integratePlane(read_only image3d_t pool, sampler_t pool_sampler, global unsigned int* oct_index, global unsigned int* oct_brick, constant float* data_extent, constant int* misc_int, global float* result, float3 base_pos, float3 a, float3 b, float3 c, int3 samples_abc, local float* addition_array) {
  int3 id_loc = (int3)(get_local_id(0), get_local_id(1), get_local_id(2));
  int3 id_glb = (int3)(get_global_id(0), get_global_id(1), get_global_id(2));
  int3 id_grp = (int3)(get_group_id(0), get_group_id(1), get_group_id(2));
  int3 size_grp = (int3)(get_num_groups(0), get_num_groups(1), get_num_groups(2));
  int3 size_loc = (int3)(get_local_size(0), get_local_size(1), get_local_size(2));
  int3 size_glb = (int3)(get_global_size(0), get_global_size(1), get_global_size(2));

  int3 size_problem = (int3)(samples_abc.x, samples_abc.y, samples_abc.z);

  int id_loc_linear = id_loc.z;
  int id_result = id_grp.x + id_grp.y * size_grp.x;
  int size_loc_linear = size_loc.x * size_loc.y * size_loc.z;

  if (id_loc_linear == 0) {
    result[hook(6, id_result)] = 0;
  }

  for (int iter = 0; iter < (size_problem.z / size_loc_linear + 1); iter++) {
    int3 id_problem = (int3)(id_grp.x, id_grp.y, id_loc_linear + iter * size_loc_linear);

    if ((id_problem.z < size_problem.z)) {
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

      float3 pos = base_pos + (float3)(a.x * ((float)id_problem.x) + b.x * ((float)id_problem.y) + c.x * ((float)id_problem.z), a.y * ((float)id_problem.x) + b.y * ((float)id_problem.y) + c.y * ((float)id_problem.z), a.z * ((float)id_problem.x) + b.z * ((float)id_problem.y) + c.z * ((float)id_problem.z));

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
            addition_array[hook(12, id_loc_linear)] = 0;
          } else {
            brick = oct_brick[hook(3, index)];
            brick_id = (uint4)((brick & mask_brick_id_x) >> 20, (brick & mask_brick_id_y) >> 10, brick & mask_brick_id_z, 0);

            lookup_pos = native_divide(0.5f + convert_float4(brick_id * brick_dim) + (float4)(norm_pos, 0.0f) * 3.5f, convert_float4(pool_dim));

            addition_array[hook(12, id_loc_linear)] = read_imagef(pool, pool_sampler, lookup_pos).w;
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
      addition_array[hook(12, id_loc_linear)] = 0;
    }

    barrier(0x01);

    for (unsigned int i = size_loc_linear / 2; i > 0; i >>= 1) {
      if (id_loc_linear < i) {
        addition_array[hook(12, id_loc_linear)] += addition_array[hook(12, i + id_loc_linear)];
      }

      barrier(0x01);
    }

    if (id_loc_linear == 0) {
      result[hook(6, id_result)] += addition_array[hook(12, 0)];
    }
  }
}