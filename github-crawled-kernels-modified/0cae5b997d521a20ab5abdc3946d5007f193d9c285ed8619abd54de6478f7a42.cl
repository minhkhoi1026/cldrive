//{"Rrow1":4,"Rrow2":5,"Rrow3":6,"camera":7,"dims":9,"f":8,"gradient":1,"image":3,"scales":10,"transfer_function":2,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x20;
int intersect_box(float3 origin, float3 direction, float3 box_min, float3 box_max, float* t_near, float* t_far) {
  float3 direction_inv = 1.0f / direction;
  float3 t_bottom = direction_inv * (box_min - origin);
  float3 t_top = direction_inv * (box_max - origin);

  float3 t_min = min(t_top, t_bottom);
  float3 t_max = max(t_top, t_bottom);

  float largest_t_min = max(max(t_min.x, t_min.y), max(t_min.x, t_min.z));
  float smallest_t_max = min(min(t_max.x, t_max.y), min(t_max.x, t_max.z));

  *t_near = largest_t_min;
  *t_far = smallest_t_max;

  return largest_t_min < smallest_t_max;
};

kernel void raytracing(read_only image3d_t volume, read_only image3d_t gradient, read_only image1d_t transfer_function, write_only image2d_t image, float3 Rrow1, float3 Rrow2, float3 Rrow3, float3 camera, float2 f, float3 dims, float3 scales) {
  float2 wh = (float2)(get_global_size(0), get_global_size(1));
  int2 uv = (int2)(get_global_id(0), get_global_id(1));

  float3 dir_camera = (float3)((2.0f * uv.x / wh.x - 1.0f) / f.x, (1.0f - 2.0f * uv.y / wh.y) / f.y, -1.0f);
  float3 dir_world = (float3)(dot(dir_camera, Rrow1), dot(dir_camera, Rrow2), dot(dir_camera, Rrow3));

  float epsilon = 1e-10f;
  dir_world.x = (fabs(dir_world.x) < epsilon) ? epsilon : dir_world.x;
  dir_world.y = (fabs(dir_world.y) < epsilon) ? epsilon : dir_world.y;
  dir_world.z = (fabs(dir_world.z) < epsilon) ? epsilon : dir_world.z;

  float3 bound_max = dims * scales;
  float max_bound = max(max(bound_max.x, bound_max.y), bound_max.z);
  bound_max /= max_bound;
  float3 bound_min = -bound_max;

  float t_near, t_far;
  int hit = intersect_box(camera, dir_world, bound_min, bound_max, &t_near, &t_far);
  if (!hit) {
    write_imagef(image, uv, (float4)(0.0f, 0.0f, 0.0f, 1.0f));
    return;
  }

  float3 voxel_size = (bound_max - bound_min) / dims;
  float t_step = 0.8f * voxel_size.x;
  int max_iteration = (int)(dims.x + dims.y + dims.z);

  float t = (t_near < 0) ? 0 : t_near;
  float4 dst = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 src;

  int cnt = 0;

  bool has_entered_region = false;
  float prev_grad_len = 2.0f;

  for (;; cnt++) {
    float3 p = camera + t * dir_world;
    float4 volume_index = (float4)(((p.x - bound_min.x) / voxel_size.x), (dims.y - (p.y - bound_min.y) / voxel_size.y), (dims.z - (p.z - bound_min.z) / voxel_size.z), 1.0f);
    float4 voxel_value = read_imagef(volume, sampler, volume_index);
    float4 grad_value = read_imagef(gradient, sampler, volume_index);

    if (!has_entered_region && length(grad_value) > 0) {
      has_entered_region = true;
    }

    if (has_entered_region) {
      if (length(grad_value) - prev_grad_len < 0)
        prev_grad_len = length(grad_value);
      else {
        float4 d = (float4)(camera - p, 1.0f);
        float shade = fabs(dot(normalize(d), normalize(grad_value)));
        dst = (float4)(1.0f, 1.0f, 1.0f, 1.0f) * shade;
        break;
      }
    }

    t += t_step;
    if (t > t_far)
      break;
  }
  write_imagef(image, uv, dst);
}