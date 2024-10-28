//{"ex":7,"ey":8,"ez":6,"out":9,"rx":2,"ry":3,"sh":5,"sw":4,"x":0,"y":1}
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

kernel void distance_2_point(global float* x, global float* y, float rx, float ry, float sw, float sh, global float* ez, global float* ex, global float* ey, global float* out) {
  unsigned int i = get_global_id(0);
  out[hook(9, i)] = _distance_2_point(x[hook(0, i)], y[hook(1, i)], rx, ry, sw, sh, ez[hook(6, i)], ex[hook(7, i)], ey[hook(8, i)]);
}