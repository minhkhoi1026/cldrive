//{"full_sum":3,"image_1":0,"image_2":1,"local_sums":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float3 raycast(const float3 plane_normal, const float3 plane_origin, const float3 ray_direction, const float3 ray_origin) {
  const float d = dot((plane_origin - ray_origin), plane_normal) / dot(ray_direction, plane_normal);
  return ray_origin + (d * ray_direction);
}

kernel void sum_squared_diff(read_only image2d_t image_1, read_only image2d_t image_2, global float* local_sums, global float* full_sum) {
  const int2 read_coord = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 4 | 0x10;

  const float im1_val = read_imagef(image_1, smp, read_coord).x;
  const float im2_val = read_imagef(image_2, smp, read_coord).x;
  const float error = (im1_val - im2_val) / 255.0;
  const float error_sq = error * error;
  const float sum_partial = work_group_reduce_add(error_sq);

  const int write_loc = get_group_id(1);

  const int local_col = get_local_id(0);
  const int local_row = get_local_id(1);
  if (local_row == 0 && local_col == 0) {
    local_sums[hook(2, write_loc)] = sum_partial / ((float)get_local_size(0));
  }

  barrier(0x02);
  if (get_group_id(1) == 0) {
    if (local_row == 0 && local_col == 0) {
      float total = 0.0;
      for (int k = 0; k < 270; ++k) {
        total += local_sums[hook(2, k)];
      }
      full_sum[hook(3, 0)] = total;
    }
  }
}