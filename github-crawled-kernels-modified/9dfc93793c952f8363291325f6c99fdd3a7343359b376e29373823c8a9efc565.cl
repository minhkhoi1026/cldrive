//{"angle":6,"cam_distance":7,"eye_x":2,"eye_y":3,"eye_z":4,"screen":8,"screen_z":5,"volume_size":1,"voxels":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
bool intersect(float3 ray_origin, float3 ray_direction, float3 box_a, float3 box_b, float3* box_intersection) {
  float ray_length_enter_box = -1000000000;
  float ray_length_leave_box = 1000000000;

  if (ray_direction.x != 0) {
    float distance_to_a_along_x = (box_a.x - ray_origin.x) / ray_direction.x;
    float distance_to_b_along_x = (box_b.x - ray_origin.x) / ray_direction.x;
    ray_length_enter_box = min(distance_to_a_along_x, distance_to_b_along_x);
    ray_length_leave_box = max(distance_to_a_along_x, distance_to_b_along_x);
  }

  if (ray_direction.y != 0) {
    float distance_to_a_along_y = (box_a.y - ray_origin.y) / ray_direction.y;
    float distance_to_b_along_y = (box_b.y - ray_origin.y) / ray_direction.y;
    ray_length_enter_box = max(ray_length_enter_box, min(distance_to_a_along_y, distance_to_b_along_y));
    ray_length_leave_box = min(ray_length_leave_box, max(distance_to_a_along_y, distance_to_b_along_y));
  }

  if (ray_direction.z != 0) {
    float distance_to_a_along_z = (box_a.z - ray_origin.z) / ray_direction.z;
    float distance_to_b_along_z = (box_b.z - ray_origin.z) / ray_direction.z;
    ray_length_enter_box = max(ray_length_enter_box, min(distance_to_a_along_z, distance_to_b_along_z));
    ray_length_leave_box = min(ray_length_leave_box, max(distance_to_a_along_z, distance_to_b_along_z));
  }

  if (ray_length_enter_box <= ray_length_leave_box) {
    *box_intersection = ray_origin + ray_direction * ray_length_enter_box;
    return true;
  }
  return false;
}

kernel void render(global const int* voxels, int volume_size, int eye_x, int eye_y, int eye_z, int screen_z, float angle, float cam_distance, write_only image2d_t screen) {
  int screen_width = get_image_dim(screen).x;
  int screen_height = get_image_dim(screen).y;
  int screen_x = get_global_id(0) - screen_width / 2;
  int screen_y = screen_height / 2 - get_global_id(1);

  float3 eye = (float3)(eye_x, eye_y, eye_z);
  float3 pixel = (float3)(screen_x, screen_y, screen_z);
  float3 dir = normalize(pixel - eye);

  float3 origin = normalize(eye);
  float new_origin_x = cam_distance * (origin.x * cos(angle) - origin.z * sin(angle));
  float new_origin_z = cam_distance * (origin.x * sin(angle) + origin.z * cos(angle));
  origin.x = new_origin_x;
  origin.z = new_origin_z;

  float new_dir_x = dir.x * cos(angle) - dir.z * sin(angle);
  float new_dir_z = dir.x * sin(angle) + dir.z * cos(angle);
  dir.x = new_dir_x;
  dir.z = new_dir_z;

  float distance = 0;
  float3 box_intersection = (float3)(0, 0, 0);
  float3 box_a = (float3)(-volume_size / 2, -volume_size / 2, -volume_size / 2);
  float3 box_b = (float3)(volume_size / 2, volume_size / 2, volume_size / 2);
  if (intersect(origin, dir, box_a, box_b, &box_intersection)) {
    for (int i = 0; i < volume_size; i++) {
      unsigned int voxel_coord_x = (int)(box_intersection.x + dir.x * i + volume_size / 2);
      unsigned int voxel_coord_y = volume_size - (int)(box_intersection.y + dir.y * i + volume_size / 2);
      unsigned int voxel_coord_z = volume_size - (int)(box_intersection.z + dir.z * i + volume_size / 2);
      if (voxel_coord_x > volume_size || voxel_coord_y > volume_size || voxel_coord_z > volume_size) {
        distance = 0;
      } else {
        unsigned int index = voxel_coord_z * volume_size * volume_size + voxel_coord_y * volume_size + voxel_coord_x;
        int voxel = voxels[hook(0, index)];
        if (voxel != 0) {
          distance = 255 - voxel;
          break;
        }
      }
    }
  }

  uint4 write_pixel = (uint4)(distance);
  write_imageui(screen, (int2)(get_global_id(0), get_global_id(1)), write_pixel);
}