//{"angle_offset":5,"in_weight":9,"max_dist":7,"min_dist":6,"out_weight":10,"probabilities":2,"width":8,"x":3,"xs":0,"y":4,"ys":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float mod(float x, float p) {
  return x - p * floor(x / p);
}

float angle_from(float x, float y, float angle_offset) {
  float angle = atan2(y, x);
  angle = mod(angle - angle_offset, 2 * 3.14159265358979323846f);

  angle -= (2 * 3.14159265358979323846f) * (angle > 3.14159265358979323846f);
  return angle;
}

float angle_clamp(float angle, float coefficient) {
  return fmax(fmin(1.05 - coefficient * fabs(angle), 1), 0);
}

float narrow_angle_clamp(float angle) {
  return fmax(fmin(1.05 - 6 * fabs(angle), 1), 0);
}
float inferred_angle_clamp(float angle) {
  return fmax(fmin(1.05 - 4 * fabs(angle), 1), 0);
}
float wide_angle_clamp(float angle) {
  return fmax(fmin(1.05 - 2 * fabs(angle), 1), 0);
}
kernel void evidence(global const float* xs, global const float* ys, global float* probabilities, float x, float y, float angle_offset, float min_dist, float max_dist, float width, float in_weight, float out_weight) {
  int gid = get_global_id(0);

  float rel_x = xs[hook(0, gid)] - x;
  float rel_y = ys[hook(1, gid)] - y;

  float angle = angle_from(rel_x, rel_y, angle_offset);

  float evidence = angle_clamp(angle, width);

  float dist = (rel_x) * (rel_x) + (rel_y) * (rel_y);

  evidence *= (dist > min_dist) * (dist < max_dist);

  probabilities[hook(2, gid)] *= (in_weight - out_weight) * evidence + out_weight;
}