//{"force":2,"num":0,"pos":1,"pos_shared":3}
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

kernel void NBody_force(unsigned int num, global float2* pos, global float2* force) {
  const int iG = get_global_id(0);
  const int iL = get_local_id(0);
  const int nL = get_local_size(0);
  local float2 pos_shared[64];
  float2 p = pos[hook(1, iG)];
  float2 f = (float2)(0.0f, 0.0f);
  for (int i0 = 0; i0 < num; i0 += nL) {
    pos_shared[hook(3, iL)] = pos[hook(1, i0 + iL)];
    barrier(0x01);
    for (int j = 0; j < nL; j++) {
      float2 pj = pos_shared[hook(3, j)];
      f += pair_force(p, pj);
    }
    barrier(0x01);
  }
  force[hook(2, iG)] = f;
}