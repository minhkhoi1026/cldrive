//{"blendmap":1,"out":2,"pyramid":0}
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

kernel void blend(read_only image3d_t pyramid, read_only image2d_t blendmap, write_only image2d_t out) {
  unsigned int y = get_global_id(0);
  unsigned int x = get_global_id(1);

  float4 bm = read_imagef(blendmap, (int2)(y, x));

  float4 v1 = read_imagef(pyramid, (int4)(bm.w, y, x, 0));
  float4 v2 = read_imagef(pyramid, (int4)(bm.w - 1, y, x, 0));

  float4 pixel = v1 * (1 - bm.z) + v2 * bm.z;

  write_imagef(out, (int2)(y, x), pixel);
}