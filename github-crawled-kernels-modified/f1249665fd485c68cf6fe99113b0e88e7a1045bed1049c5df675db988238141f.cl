//{"dest":1,"height":3,"max_val":4,"src":0,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float get(global float* src, int width, int height, int x, int y, float default_value) {
  if (0 <= x && x < width && 0 <= y && y < height) {
    return src[hook(0, y * width + x)];
  } else {
    return default_value;
  }
}

inline uchar4 gray(const float percentage) {
  const unsigned char v = (unsigned char)(percentage * 255);
  return (uchar4)(v, v, v, 1);
}

inline float hue_to_rgb(const float p, const float q, const float _t) {
  float t = _t;
  if (t < 0.0f)
    t += 1;
  if (t > 1.0f)
    t -= 1;
  if (t < 1.0f / 6.0f)
    return p + (q - p) * 6.0f * t;
  if (t < 1.0f / 2.0f)
    return q;
  if (t < 2.0f / 3.0f)
    return p + (q - p) * (2.0f / 3.0f - t) * 6.0f;
  return p;
}

inline uchar4 hsl_to_rgb(const float h, const float s, const float l) {
  float r, g, b;

  if (s == 0.0f) {
    r = g = b = l;
  } else {
    const float q = l < 0.5f ? l * (1.0f + s) : l + s - l * s;
    const float p = 2 * l - q;
    r = hue_to_rgb(p, q, h + 1.0f / 3.0f);
    g = hue_to_rgb(p, q, h);
    b = hue_to_rgb(p, q, h - 1.0f / 3.0f);
  }
  return (uchar4)((unsigned char)(r * 255.0f), (unsigned char)(g * 255.0f), (unsigned char)(b * 255.0f), 1);
}

kernel void map_hsl(global float* src, global uchar4* dest, int width, int height, float max_val) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x < width && y < height) {
    const int idx = y * width + x;
    const float v = src[hook(0, idx)];
    const float p = (v < max_val ? v : max_val) / max_val;
    dest[hook(1, idx)] = hsl_to_rgb(p, 0.5f, 0.5f);
  }
}