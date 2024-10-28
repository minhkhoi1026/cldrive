//{"cumulative_rgb":6,"exponent":4,"hist_inten":5,"in":0,"intensities":3,"mask_radius":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_oilify_inten(global float4* in, global float4* out, const int mask_radius, const int intensities, const float exponent) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int x = gidx + mask_radius;
  int y = gidy + mask_radius;
  int dst_width = get_global_size(0);
  int src_width = dst_width + mask_radius * 2;
  float4 cumulative_rgb[256];
  int hist_inten[256], inten_max;
  int i, j, intensity;
  int radius_sq = mask_radius * mask_radius;
  float4 temp_pixel;
  for (i = 0; i < intensities; i++) {
    hist_inten[hook(5, i)] = 0;
    cumulative_rgb[hook(6, i)] = 0.0;
  }
  for (i = -mask_radius; i <= mask_radius; i++) {
    for (j = -mask_radius; j <= mask_radius; j++) {
      if (i * i + j * j <= radius_sq) {
        temp_pixel = in[hook(0, x + i + (y + j) * src_width)];

        intensity = (int)((0.299 * temp_pixel.x + 0.587 * temp_pixel.y + 0.114 * temp_pixel.z) * (float)(intensities - 1));
        hist_inten[hook(5, intensity)] += 1;
        cumulative_rgb[hook(6, intensity)] += temp_pixel;
      }
    }
  }
  inten_max = 1;

  for (i = 0; i < intensities; i++) {
    if (hist_inten[hook(5, i)] > inten_max)
      inten_max = hist_inten[hook(5, i)];
  }
  float div = 0.0;
  float ratio, weight, mult_inten;

  float4 float3 = 0.0;
  for (i = 0; i < intensities; i++) {
    if (hist_inten[hook(5, i)] > 0) {
      ratio = (float)(hist_inten[hook(5, i)]) / (float)(inten_max);
      weight = pow(ratio, exponent);
      mult_inten = weight / (float)(hist_inten[hook(5, i)]);

      div += weight;
      float3 += mult_inten * cumulative_rgb[hook(6, i)];
    }
  }
  out[hook(1, gidx + gidy * dst_width)] = float3 / div;
}