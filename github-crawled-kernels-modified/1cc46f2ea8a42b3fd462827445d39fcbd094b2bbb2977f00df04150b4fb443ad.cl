//{"frequency":2,"heightmap":1,"octaves":4,"persistence":3,"random_values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float Cosine_Interpolate(float a, float b, float x) {
  float ft = x * 3.1415927f;
  float f = (1.0f - cos(ft)) * 0.5f;

  return a * (1 - f) + b * f;
}

float Noise(int x, int y) {
  int n = x + y * 57;
  n = (n << 13) ^ n;
  return (1.f - ((n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
}

float4 imageNoise(int x, int y, read_only image2d_t random_values) {
  int2 coords = (int2)(x, y);
  int2 s = get_image_dim(random_values);
  if (coords.x < 0)
    coords.x = 0;
  else if (coords.x >= s.x)
    coords.x = s.x - 1;
  if (coords.y < 0)
    coords.y = 0;
  else if (coords.y >= s.y)
    coords.y = s.y - 1;

  return read_imagef(random_values, sampler, coords);
}

float SmoothedNoise1(float x, float y, read_only image2d_t random_values) {
  float corners = (imageNoise(x - 1, y - 1, random_values).x + imageNoise(x + 1, y - 1, random_values).x + imageNoise(x - 1, y + 1, random_values).x + imageNoise(x + 1, y + 1, random_values).x) / 16.0f;
  float sides = (imageNoise(x - 1, y, random_values).x + imageNoise(x + 1, y, random_values).x + imageNoise(x, y - 1, random_values).x + imageNoise(x, y + 1, random_values)).x / 8.0f;
  float center = imageNoise(x, y, random_values).x / 4.0f;
  return corners + sides + center;
}

float InterpolatedNoise1(float x, float y, read_only image2d_t random_values) {
  int integer_X = (int)floor(x);
  float fractional_X = fabs(x - integer_X);

  int integer_Y = (int)floor(y);
  float fractional_Y = fabs(y - integer_Y);

  float v1 = SmoothedNoise1(integer_X, integer_Y, random_values);
  float v2 = SmoothedNoise1(integer_X + 1, integer_Y, random_values);
  float v3 = SmoothedNoise1(integer_X, integer_Y + 1, random_values);
  float v4 = SmoothedNoise1(integer_X + 1, integer_Y + 1, random_values);

  float i1 = Cosine_Interpolate(v1, v2, fractional_X);
  float i2 = Cosine_Interpolate(v3, v4, fractional_X);

  return Cosine_Interpolate(i1, i2, fractional_Y);
}

float GetPerlin(float x, float y, float frequency, float persistence, int octaves, read_only image2d_t random_values) {
  float total = 0.0f;
  float p = persistence;
  float freq = frequency;
  int n = octaves - 1;

  for (int i = 0; i < n; ++i) {
    float frequency2 = pow(freq, (float)i);
    float amplitude = pow(p, (float)i);

    total = total + InterpolatedNoise1(x * frequency2, y * frequency2, random_values) * amplitude;
  }

  return total;
}

kernel void perlinnoise(read_only image2d_t random_values, write_only image2d_t heightmap, global float* frequency, global float* persistence, global int* octaves) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);

  float out = GetPerlin(x, y, *frequency, *persistence, *octaves, random_values);
  float4 outvalue;
  outvalue.x = out;
  outvalue.y = out;
  outvalue.z = out;
  outvalue.w = 1.0f;
  write_imagef(heightmap, coord, outvalue);
}