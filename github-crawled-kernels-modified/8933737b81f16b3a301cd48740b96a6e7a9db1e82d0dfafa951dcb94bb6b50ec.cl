//{"exponent":4,"hist":5,"in":0,"intensities":3,"mask_radius":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_oilify(global float4* in, global float4* out, const int mask_radius, const int intensities, const float exponent) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int x = gidx + mask_radius;
  int y = gidy + mask_radius;
  int dst_width = get_global_size(0);
  int src_width = dst_width + mask_radius * 2;
  float4 hist[256];
  float4 hist_max = 1.0;
  int i, j, intensity;
  int radius_sq = mask_radius * mask_radius;
  float4 temp_pixel;
  for (i = 0; i < intensities; i++)
    hist[hook(5, i)] = 0.0;

  for (i = -mask_radius; i <= mask_radius; i++) {
    for (j = -mask_radius; j <= mask_radius; j++) {
      if (i * i + j * j <= radius_sq) {
        temp_pixel = in[hook(0, x + i + (y + j) * src_width)];
        hist[hook(5, (int)(temp_pixel.x * (intensities - 1)))].x += 1;
        hist[hook(5, (int)(temp_pixel.y * (intensities - 1)))].y += 1;
        hist[hook(5, (int)(temp_pixel.z * (intensities - 1)))].z += 1;
        hist[hook(5, (int)(temp_pixel.w * (intensities - 1)))].w += 1;
      }
    }
  }

  for (i = 0; i < intensities; i++) {
    if (hist_max.x < hist[hook(5, i)].x)
      hist_max.x = hist[hook(5, i)].x;
    if (hist_max.y < hist[hook(5, i)].y)
      hist_max.y = hist[hook(5, i)].y;
    if (hist_max.z < hist[hook(5, i)].z)
      hist_max.z = hist[hook(5, i)].z;
    if (hist_max.w < hist[hook(5, i)].w)
      hist_max.w = hist[hook(5, i)].w;
  }
  float4 div = 0.0;
  float4 sum = 0.0;
  float4 ratio, weight;
  for (i = 0; i < intensities; i++) {
    ratio = hist[hook(5, i)] / hist_max;
    weight = pow(ratio, (float4)exponent);
    sum += weight * (float4)i;
    div += weight;
  }
  out[hook(1, gidx + gidy * dst_width)] = sum / div / (float)(intensities - 1);
}