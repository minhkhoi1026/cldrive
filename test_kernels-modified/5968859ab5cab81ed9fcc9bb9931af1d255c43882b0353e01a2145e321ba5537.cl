//{"bitmap_h":6,"bitmap_w":5,"camera_lookat":8,"camera_pos":7,"printings":9,"ray_dirs":4,"volume":0,"volume_h":2,"volume_n":3,"volume_w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void build_ray_dirs(global unsigned char* volume, int volume_w, int volume_h, int volume_n, global float4* ray_dirs, int bitmap_w, int bitmap_h, float4 camera_pos, float4 camera_lookat, global float* printings) {
  int n = get_global_id(0);
  if (n >= bitmap_w * bitmap_h)
    return;

  int ray_x = n % bitmap_w;
  int ray_y = n / bitmap_w;

  float4 camera_forward = normalize(camera_lookat - camera_pos);
  float4 temp_up = {0, 1, 0, 0};
  float4 camera_right = normalize(cross(temp_up, camera_forward));
  float4 camera_up = normalize(cross(camera_right, camera_forward));

  float fov_hor = 45 / 2;
  float fov_ver = fov_hor * bitmap_h / (float)bitmap_w;
  fov_hor = fov_hor / 180.0f * 3.14f;
  fov_ver = fov_ver / 180.0f * 3.14f;

  float4 step_forward = camera_forward;

  float temp = (ray_x - bitmap_w / 2) / (float)(bitmap_w / 2);
  float4 step_right = temp * fov_hor * camera_right;

  temp = (ray_y - bitmap_h / 2) / (float)(bitmap_h / 2);
  float4 step_up = temp * fov_ver * camera_up;
  float4 ray_dir = normalize(step_forward + step_right + step_up);

  ray_dirs[hook(4, n)] = ray_dir;
}