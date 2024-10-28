//{"blur_diameter":2,"image_in":0,"image_out":1,"img_height":4,"img_width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x20;
kernel void fast_blur_v(read_only image2d_t image_in, write_only image2d_t image_out, float blur_diameter, int img_width, int img_height) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  float2 sample_coord = (float2)(x + .5f, y + .5f);

  float4 sum = read_imagef(image_in, sampler, sample_coord);

  if (blur_diameter > 0.0f) {
    float blur_radius_in_pixels = img_height * (blur_diameter / 2.0f);
    int side_samples = floor(blur_radius_in_pixels);

    float total_weights = 1.f;
    float sample_weight;

    for (int i = 1; i <= side_samples; i++) {
      sample_weight = (side_samples - i) / blur_radius_in_pixels;
      total_weights += sample_weight * 2;
      sum += read_imagef(image_in, sampler, sample_coord + (float2)(0.0f, i)) * sample_weight;
      sum += read_imagef(image_in, sampler, sample_coord - (float2)(0.0f, i)) * sample_weight;
    }

    sum /= total_weights;
    write_imagef(image_out, (int2)(x, y), sum);
  }
  write_imagef(image_out, (int2)(x, y), sum);
}