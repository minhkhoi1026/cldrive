//{"image1":0,"image2":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float3 raycast(const float3 plane_normal, const float3 plane_origin, const float3 ray_direction, const float3 ray_origin) {
  const float d = dot((plane_origin - ray_origin), plane_normal) / dot(ray_direction, plane_normal);
  return ray_origin + (d * ray_direction);
}

kernel void ssd_r(read_only image2d_t image1, read_only image2d_t image2, write_only image2d_t output) {
  const sampler_t smp = 0 | 4 | 0x10;

  const int col = get_global_id(0);
  const int row = get_global_id(1);

  const int2 translation = (int2)(col, row);

  const int2 im1_size = get_image_dim(image1);
  const int2 im2_size = get_image_dim(image2);

  const int region_size = 50;
  const int half_region_size = region_size / 2;
  int ustart = max(col - half_region_size, 0);
  int uend = min(col + half_region_size, im1_size.x);

  int vstart = max(row - half_region_size, 0);
  int vend = min(row + half_region_size, im1_size.y);

  for (int u1 = ustart; u1 < uend; ++u1) {
    for (int v1 = vstart; v1 < vend; ++v1) {
      const int2 coord = (int2)(u1, v1);
      const float4 px_uv = read_imagef(image1, smp, coord).x;
    }
  }
}