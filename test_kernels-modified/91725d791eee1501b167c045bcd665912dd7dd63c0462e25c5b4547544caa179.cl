//{"alive":2,"old_score":1,"score":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float cross2d(float2 a, float2 b) {
  return a.x * b.y - a.y * b.x;
}

float dot2d(float2 a, float2 b) {
  return a.x * b.x + a.y * b.y;
}

float2 perp(float2 a) {
  return (float2)(-a.y, a.x);
}

float2 rotate2d(float orientation, float2 input) {
  float cs = cos(radians(orientation));
  float sn = sin(radians(orientation));
  return (float2)(input.x * cs - input.y * sn, input.x * sn + input.y * cs);
}

kernel void evaluate_score(global float* score, global float* old_score, global float* alive) {
  int gid = get_global_id(0);
  if (length(score[hook(0, gid)] - old_score[hook(1, gid)]) < 0.75f) {
    alive[hook(2, gid)] = 0;
  }
}