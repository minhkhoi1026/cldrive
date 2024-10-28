//{"average_color":3,"in":0,"intensity_count":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void video_image(read_only image2d_t in, write_only image2d_t out) {
  const sampler_t format = 0 | 0x10 | 4;
  const int2 d = (int2)(get_global_id(0), get_global_id(1));
  int intensity_count[20];
  float4 average_color[20];

  for (int i = 0; i < 20; ++i) {
    intensity_count[hook(2, i)] = 0;
    average_color[hook(3, i)] = (float4)(0.0f, 0.0f, 0.0f, 1.0f);
  }

  for (int x = d.x - 3; x < d.x + 3; ++x) {
    for (int y = d.y - 3; y < d.y + 3; ++y) {
      float2 abs_pos = (float2)(d.x - x, d.y - y);
      if ((3 * 3) < dot(abs_pos, abs_pos))
        continue;
      float4 color_element = read_imagef(in, format, (int2)(x, y));
      int current_intensity = (dot(color_element, (float4)(1.0f, 1.0f, 1.0f, 0.0f)) / 3.0f) * 20;
      current_intensity = (current_intensity >= 20) ? 20 - 1 : current_intensity;
      intensity_count[hook(2, current_intensity)] += 1;
      average_color[hook(3, current_intensity)] += color_element;
    }
  }

  int max_level = 0;
  int max_index = 0;
  for (int level = 0; level < 20; ++level) {
    if (intensity_count[hook(2, level)] > max_level) {
      max_level = intensity_count[hook(2, level)];
      max_index = level;
    }
  }

  float4 out_col = average_color[hook(3, max_index)] / max_level;
  out_col.w = 1.0f;
  write_imagef(out, d, out_col);
}