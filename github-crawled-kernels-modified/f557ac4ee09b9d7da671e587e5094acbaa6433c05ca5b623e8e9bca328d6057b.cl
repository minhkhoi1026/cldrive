//{"ce":0,"cx":2,"cy":3,"ex":9,"ey":10,"ez":8,"levels":11,"map":12,"rx":4,"ry":5,"sh":7,"sw":6,"var":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float _distance_2_point(float x, float y, float rx, float ry, float sw, float sh, float ez, float ex, float ey) {
  float dx = x / rx * sw - sw / 2.0f + ex;
  float dy = y / ry * sh - sh / 2.0f - ey;
  return sqrt(ez * ez + dx * dx + dy * dy);
}

inline float _subtended_angle(float x1, float y1, float x2, float y2, float rx, float ry, float sw, float sh, float ez, float ex, float ey) {
  float d1 = _distance_2_point(x1, y1, rx, ry, sw, sh, ez, ex, ey);
  float d2 = _distance_2_point(x2, y2, rx, ry, sw, sh, ez, ex, ey);
  float dX = sw * (x2 - x1) / rx;
  float dY = sh * (y2 - y1) / ry;
  float dS = sqrt(dX * dX + dY * dY);
  float w1 = d1 * d1 + d2 * d2 - dS * dS;
  float w2 = 2.0f * d1 * d2;
  return acos(min(max(w1 / w2, -1.0f), 1.0f)) * 180.0f / 3.14159265358979323846264338327950288f;
}

kernel void blendmap(constant float* ce, constant float* var, float cx, float cy, float rx, float ry, float sw, float sh, float ez, float ex, float ey, unsigned int levels, write_only image2d_t map) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  float4 pixel = 0.f;

  pixel.x = _subtended_angle(x, y, cx, cy, rx, ry, sw, sh, ez, ex, ey);

  unsigned int l;
  for (l = 0; l <= levels; l++) {
    if (pixel.x >= ce[hook(0, l)] && pixel.x < ce[hook(0, l + 1)])
      break;
  }

  if (l == 0) {
    pixel.y = 1.0f;
    pixel.z = 1.0f;
    pixel.w = 1.0f;
  } else if (l == levels) {
    pixel.y = 1.0f / (1 << (levels - 1));
    pixel.z = 0.0f;
    pixel.w = levels - 1.0f;
  } else {
    float hres = 1.0f / (1 << (l - 1));
    float lres = 1.0f / (1 << l);
    pixel.y = (lres * (pixel.x - ce[hook(0, l)]) + hres * (ce[hook(0, l + 1)] - pixel.x)) / (ce[hook(0, l + 1)] - ce[hook(0, l)]);
    float t1 = exp(-pixel.y * pixel.y / (2.0f * var[hook(1, l)] * var[hook(1, l)]));
    float t2 = exp(-pixel.y * pixel.y / (2.0f * var[hook(1, l - 1)] * var[hook(1, l - 1)]));
    pixel.z = (0.5f - t1) / (t2 - t1);
    if (pixel.z < 0)
      pixel.z = 0.0f;
    if (pixel.z > 1)
      pixel.z = 1.0f;
    pixel.w = l;
  }

  write_imagef(map, (int2)(x, y), pixel);
}