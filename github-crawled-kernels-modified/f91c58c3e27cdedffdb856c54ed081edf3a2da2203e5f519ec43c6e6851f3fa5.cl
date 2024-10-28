//{"brick_dim":7,"brick_sampler":5,"data_extent":3,"data_view_extent":4,"n_tree_levels":6,"oct_brick":2,"oct_index":1,"output":8,"pool":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sampleScatteringVolume(read_only image3d_t pool, global unsigned int* oct_index, global unsigned int* oct_brick, constant float* data_extent, constant float* data_view_extent, sampler_t brick_sampler, unsigned int n_tree_levels, unsigned int brick_dim, global float* output) {
  int4 pool_dim = get_image_dim(pool);

  float3 pos;
  pos.x = data_view_extent[hook(4, 0)] + (data_view_extent[hook(4, 1)] - data_view_extent[hook(4, 0)]) * native_divide((float)get_global_id(0) + 0.5f, (float)get_global_size(0));
  pos.y = data_view_extent[hook(4, 2)] + (data_view_extent[hook(4, 3)] - data_view_extent[hook(4, 2)]) * native_divide((float)get_global_id(1) + 0.5f, (float)get_global_size(1));
  pos.z = data_view_extent[hook(4, 4)] + (data_view_extent[hook(4, 5)] - data_view_extent[hook(4, 4)]) * native_divide((float)get_global_id(2) + 0.5f, (float)get_global_size(2));

  unsigned int node_brick, node_index, isMsd, is_low_enough, isEmpty;
  float4 lookup_pos;
  uint4 brick_id;
  int3 norm_index;
  float intensity, intensity_prev_lvl, intensity_this_lvl;
  float voxel_size_prev_lvl, voxel_size_this_lvl;
  float sample_interdist = native_divide(data_view_extent[hook(4, 1)] - data_view_extent[hook(4, 0)], (float)get_global_size(0));
  float volume = sample_interdist * sample_interdist * sample_interdist;

  unsigned int mask_msd_flag = ((1u << 1u) - 1u) << 31u;
  unsigned int mask_data_flag = ((1 << 1) - 1) << 30;
  unsigned int mask_child_index = ((1 << 30) - 1) << 0;
  unsigned int mask_brick_id_x = ((1 << 10) - 1) << 20;
  unsigned int mask_brick_id_y = ((1 << 10) - 1) << 10;
  unsigned int mask_brick_id_z = ((1 << 10) - 1) << 0;

  unsigned int index_this_lvl = 0;
  unsigned int index_prev_lvl = 0;

  float3 norm_pos_this_lvl = native_divide((float3)(pos.x - data_extent[hook(3, 0)], pos.y - data_extent[hook(3, 2)], pos.z - data_extent[hook(3, 4)]), (float3)(data_extent[hook(3, 1)] - data_extent[hook(3, 0)], data_extent[hook(3, 3)] - data_extent[hook(3, 2)], data_extent[hook(3, 5)] - data_extent[hook(3, 4)])) * 2.0f;
  float3 norm_pos_prev_lvl;

  norm_index = convert_int3(norm_pos_this_lvl);
  norm_index = clamp(norm_index, 0, 1);

  if ((pos.x < data_extent[hook(3, 0)]) || (pos.x > data_extent[hook(3, 1)]) || (pos.y < data_extent[hook(3, 2)]) || (pos.y > data_extent[hook(3, 3)]) || (pos.z < data_extent[hook(3, 4)]) || (pos.z > data_extent[hook(3, 5)])) {
    output[hook(8, get_global_id(0) + get_global_id(1) * get_global_size(0) + get_global_id(2) * get_global_size(0) * get_global_size(1))] = 0.0f;
  } else {
    for (int j = 0; j < n_tree_levels; j++) {
      voxel_size_this_lvl = (data_extent[hook(3, 1)] - data_extent[hook(3, 0)]) / ((float)((brick_dim - 1) * (1 << j)));

      if (j > 0) {
        voxel_size_prev_lvl = (data_extent[hook(3, 1)] - data_extent[hook(3, 0)]) / ((float)((brick_dim - 1) * (1 << (j - 1))));
      }

      node_index = oct_index[hook(1, index_this_lvl)];
      node_brick = oct_brick[hook(2, index_this_lvl)];

      isMsd = (node_index & mask_msd_flag) >> 31;
      isEmpty = !((node_index & mask_data_flag) >> 30);

      if (isMsd || isEmpty) {
        if (isEmpty) {
          intensity = 0.0f;
        } else {
          node_brick = oct_brick[hook(2, index_this_lvl)];
          brick_id = (uint4)((node_brick & mask_brick_id_x) >> 20, (node_brick & mask_brick_id_y) >> 10, node_brick & mask_brick_id_z, 0);

          lookup_pos = native_divide(0.5f + convert_float4(brick_id * brick_dim) + (float4)(norm_pos_this_lvl, 0.0f) * 3.5f, convert_float4(pool_dim));
          intensity = read_imagef(pool, brick_sampler, lookup_pos).w;
        }

        output[hook(8, get_global_id(0) + get_global_id(1) * get_global_size(0) + get_global_id(2) * get_global_size(0) * get_global_size(1))] = intensity * volume;
        break;
      } else {
        index_prev_lvl = index_this_lvl;
        norm_pos_prev_lvl = norm_pos_this_lvl;

        index_this_lvl = (node_index & mask_child_index);
        index_this_lvl += norm_index.x + norm_index.y * 2 + norm_index.z * 4;

        norm_pos_this_lvl = (norm_pos_this_lvl - (float3)((float)norm_index.x, (float)norm_index.y, (float)norm_index.z)) * 2.0f;
        norm_index = convert_int3(norm_pos_this_lvl);
        norm_index = clamp(norm_index, 0, 1);
      }
    }
  }
}