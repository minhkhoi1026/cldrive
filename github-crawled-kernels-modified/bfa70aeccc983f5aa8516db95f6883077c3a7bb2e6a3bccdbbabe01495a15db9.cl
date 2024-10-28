//{"heightmap":0,"temperaturemap":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float linear_interpolate(float x0, float x1, float alpha) {
  if (alpha > 1.0)
    alpha = 1.0;
  else if (alpha <= 0)
    alpha = 0.0;
  float interpolation = x0 * (1.0 - alpha) + alpha * x1;

  return interpolation;
}

float myabs(float i) {
  if (i < 0)
    return i * -1;
  return i;
}

kernel void temperature(read_only image2d_t heightmap, write_only image2d_t temperaturemap) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);
  int2 s = get_image_dim(temperaturemap);

  float h = read_imagef(heightmap, sampler, coord).x;

  float distance = 0;

  if (coord.y < s.y / 2.0) {
    distance = (coord.y - (s.y / 2.0)) * -1;
  } else {
    distance = coord.y - (s.y / 2.0);
  }

  float temperature1 = linear_interpolate(1.0, 0.01, distance / (s.y / 2.0));

  float height_reduced_temp = temperature1 * linear_interpolate(1.0, 0.25, h / 300.0);

  float4 outcol;
  outcol.x = height_reduced_temp * 255;
  outcol.y = outcol.x;
  outcol.z = outcol.x;
  outcol.w = 255;

  write_imagef(temperaturemap, coord, outcol);
}