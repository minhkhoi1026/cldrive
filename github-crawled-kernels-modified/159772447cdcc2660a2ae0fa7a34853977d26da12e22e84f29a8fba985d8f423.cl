//{"ex":9,"ey":10,"ez":8,"out":11,"rx":4,"ry":5,"sh":7,"sw":6,"x1":0,"x2":2,"y1":1,"y2":3}
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

kernel void subtended_angle_naive(global float* x1, global float* y1, global float* x2, global float* y2, float rx, float ry, float sw, float sh, global float* ez, global float* ex, global float* ey, global float* out) {
  unsigned int i = get_global_id(0);
  out[hook(11, i)] = _subtended_angle(x1[hook(0, i)], y1[hook(1, i)], x2[hook(2, i)], y2[hook(3, i)], rx, ry, sw, sh, ez[hook(8, i)], ex[hook(9, i)], ey[hook(10, i)]);
}