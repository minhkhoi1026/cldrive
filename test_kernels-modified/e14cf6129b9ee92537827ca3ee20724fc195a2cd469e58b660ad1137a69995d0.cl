//{"bitmap":5,"bitmap_h":7,"bitmap_w":6,"camera_lookat":9,"camera_pos":8,"printings":10,"ray_dirs":4,"volume":0,"volume_h":2,"volume_n":3,"volume_w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cast_rays(global unsigned char* volume, int volume_w, int volume_h, int volume_n, global float4* ray_dirs, global unsigned char* bitmap, int bitmap_w, int bitmap_h, float4 camera_pos, float4 camera_lookat, global float* printings) {
  int n = get_global_id(0);
  if (n >= bitmap_w * bitmap_h)
    return;

  int ray_x = n % bitmap_w;
  int ray_y = n / bitmap_w;

  float4 ray_dir = ray_dirs[hook(4, n)];

  unsigned char accum = 0;
  float t = 0;

  float4 volume_0 = {0, 0, 0, 0};
  float4 volume_1 = {volume_w - 1, volume_h - 1, volume_n - 1, 0};

  float4 foo0 = (volume_0 - camera_pos) / ray_dir;
  float4 foo1 = (volume_1 - camera_pos) / ray_dir;
  foo0 = min(foo0, foo1);
  t = max(foo0.x, max(foo0.y, foo0.z)) + 2;

  float4 t_pos = camera_pos + t * ray_dir;

  if (t_pos.x > 0 && t_pos.x < volume_w - 1 && t_pos.y > 0 && t_pos.y < volume_h - 1 && t_pos.z > 0 && t_pos.z < volume_n - 1) {
    float ray_strength = 255;
    unsigned char voxel;
    float transparency;
    while (true) {
      if (t_pos.x < 0 || t_pos.x > volume_w - 1 || t_pos.y < 0 || t_pos.y > volume_h - 1 || t_pos.z < 0 || t_pos.z > volume_n - 1) {
        break;
      }
      if (ray_strength < (255 / 10.0f))
        break;

      voxel = (volume[hook(0, ((int)t_pos.x) + ((int)t_pos.y) * volume_w + ((int)t_pos.z) * volume_w * volume_h)]);
      if (voxel < 54)
        voxel = 0;

      transparency = min((1 - voxel / 255.0f) + 0.4f, 1.0f);

      accum += ray_strength * (1 - transparency);
      ray_strength *= transparency;

      t += 1.0f;
      t_pos = camera_pos + t * ray_dir;
    }
  } else {
    accum = ((ray_x + ray_y) % 2) * 150;
  }

  bitmap[hook(5, n)] = accum;
}