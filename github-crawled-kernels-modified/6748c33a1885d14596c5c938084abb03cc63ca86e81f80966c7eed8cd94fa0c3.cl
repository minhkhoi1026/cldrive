//{"octaves":8,"output":0,"ox":2,"oy":3,"oz":4,"seed":1,"sx":5,"sy":6,"sz":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float sfract(float x) {
  return x - floor(x);
}

inline float random2(int seed, float2 point) {
  return sfract(native_sin(dot(point.xy, (float2){12.9898f, 78.233f})) * (43758.5453123f + seed));
}

inline float random3(int seed, float3 point) {
  return sfract(native_sin(dot(point.xyz, (float3){12.9898f, 78.233f, 131.27f})) * (73258.5413143f + seed));
}

inline float noise2(int seed, float2 x) {
  float2 i;
  const float2 fr = fract(x, &i);

  const float2 u = fr * fr * (3.0f - 2.0f * fr);

  const float a = random2(seed, i);
  const float b = random2(seed, i + (float2){1.0f, 0.0f});
  const float c = random2(seed, i + (float2){0.0f, 1.0f});
  const float d = random2(seed, i + (float2){1.0f, 1.0f});

  return mix(a, b, u.x) + (c - a) * u.y * (1.0f - u.x) + (d - b) * u.x * u.y;
}

inline float noise3(int seed, float3 x) {
  float3 i;
  const float3 fr = fract(x, &i);

  const float3 u = fr * fr * fr * (fr * (fr * 6.0f - 15.0f) + 10.0f);

  float a = random3(seed, i + (float3){0, 0, 0});
  float b = random3(seed, i + (float3){1, 0, 0});
  float c = random3(seed, i + (float3){0, 1, 0});
  float d = random3(seed, i + (float3){1, 1, 0});
  float e = random3(seed, i + (float3){0, 0, 1});
  float f = random3(seed, i + (float3){1, 0, 1});
  float g = random3(seed, i + (float3){0, 1, 1});
  float h = random3(seed, i + (float3){1, 1, 1});

  float k0 = a;
  float k1 = b - a;
  float k2 = c - a;
  float k3 = e - a;
  float k4 = a - b - c + d;
  float k5 = a - c - e + g;
  float k6 = a - b - e + f;
  float k7 = -a + b + c - d + e - f - g + h;

  return -1.0f + 2.0f * (k0 + k1 * u.x + k2 * u.y + k3 * u.z + k4 * u.x * u.y + k5 * u.y * u.z + k6 * u.z * u.x + k7 * u.x * u.y * u.z);
}

inline float fbm2(int seed, float2 x, int octaves) {
  float value = 0.0f;
  float amplitude = 0.5f;

  for (int i = 0; i < octaves; i++) {
    value += amplitude * noise2(seed + i, x);
    x *= 2.0f;
    amplitude *= 0.5f;
  }
  return value;
}

inline float fbm3(int seed, float3 x, int octaves) {
  float value = 0.0f;
  float amplitude = 0.5f;

  for (int i = 0; i < octaves; i++) {
    value += amplitude * noise3(seed + i, x);
    x *= 2.0f;
    amplitude *= 0.5f;
  }
  return value;
}

kernel void fbmrender3(global float* output, int seed, float ox, float oy, float oz, float sx, float sy, float sz, int octaves) {
  const int width = get_global_size(0);
  const int height = get_global_size(1);
  const int depth = get_global_size(2);

  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  float3 dim = (float3){width, height, depth};

  float3 offset = (float3){ox, oy, oz};
  float3 scale = (float3){sx, sy, sz};
  float3 pos = (float3){x, y, z} / dim;

  float value = fbm3(seed, (pos + offset) * scale, octaves);

  const int index = x + width * (y + height * z);
  output[hook(0, index)] = value;
}