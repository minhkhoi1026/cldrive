//{"force":2,"num":0,"pos":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 pair_force(float2 p1, float2 p2) {
  float2 d = p2 - p1;
  float r2 = dot(d, d);
  if (r2 > 3.24)
    return (float2)(0.0f, 0.0f);
  float ir2 = 1 / (r2 + 1.0e-2);
  float fr = (0.7 - ir2) * (3.24 - r2);
  return d * fr;
}

kernel void NBody_force_naive(unsigned int num, global float2* pos, global float2* force) {
  const int i = get_global_id(0);
  float2 p = pos[hook(1, i)];
  float2 f = (float2)(0.0f, 0.0f);
  for (int j = 0; j < num; j++) {
    float2 pj = pos[hook(1, j)];
    f += pair_force(p, pj);
  }
  force[hook(2, i)] = f;
}