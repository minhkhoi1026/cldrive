//{"random_values":0,"windmap":1}
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

float linear_interpolate(float x0, float x1, float alpha) {
  if (alpha > 1.0)
    alpha = 1.0;
  else if (alpha <= 0)
    alpha = 0.0;
  float interpolation = x0 * (1.0 - alpha) + alpha * x1;

  return interpolation;
}

float getLatitudeWinddir(float coord_y) {
  float latitude = linear_interpolate(90, -90, coord_y);
  if (latitude >= 66.33) {
    float latitude_influence = (90.0 - latitude) / 23.34;

    return linear_interpolate(3.14159, 0, latitude_influence);
  } else if (latitude < 66.33 && latitude >= 23.27) {
    float latitude_influence = (63.33 - latitude) / 43.06;
    return linear_interpolate(0, 1.570795, latitude_influence);
  } else if (latitude < 23.27 && latitude >= 0) {
    float latitude_influence = (23.27 - latitude) / 23.27;
    return linear_interpolate(1.570795, 4.712385, latitude_influence);
  } else if (latitude < 0 && latitude >= -23.27) {
    float latitude_influence = latitude / -23.27;
    return linear_interpolate(4.712385, 1.570795, latitude_influence);
  } else if (latitude < -23.27 && latitude >= -66.33) {
    float latitude_influence = (-22.27 - latitude) / 43.06;
    return linear_interpolate(1.570795, 3.14159, latitude_influence);
  } else {
    float latitude_influence = (-66.33 - latitude) / 23.34;
    return linear_interpolate(3.14159, 0, latitude_influence);
  }
}

float myabs(float i) {
  if (i < 0)
    return i * -1;
  return i;
}

kernel void winddirection(read_only image2d_t random_values, write_only image2d_t windmap) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int2 coord = (int2)(x, y);
  int2 s = get_image_dim(windmap);

  float frequency = 0.219f;
  float persistence = 1.5;
  int octaves = 3;

  float perlin = GetPerlin(x, y, frequency, persistence, octaves, random_values);

  float angle_rads = 0.0;

  float coord_y = coord.y / (float)s.y;

  float interpolated_direction = getLatitudeWinddir(coord_y);

  float random_offset = read_imagef(random_values, sampler, coord).x;

  float t = interpolated_direction;
  if (t <= 0)
    t = random_offset / 0.8;

  float4 outcol;
  outcol.x = 0;
  outcol.y = 0;
  outcol.z = 0;
  outcol.w = 255;

  t = t / perlin;
  if (t > 1.8 * 3.14159)
    t = 1.8 * 3.14159 - random_offset;
  if (t < 0.01)
    t = 0.01;
  if (t > 2 * 3.14159 || t <= 0)
    t = 0.1;

  outcol.z = t * 50;

  write_imagef(windmap, coord, outcol);
}