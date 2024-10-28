//{"force":2,"num":0,"pos":1,"pos_shared":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 force_LJ(float2 p1, float2 p2) {
  float2 d = p2 - p1;
  float ir2 = 1 / (d.x * d.x + d.y * d.y + 1.0e-2);
  float ir6 = ir2 * ir2 * ir2;
  float fr = ir6 - ir6 * ir6;
  return d * fr;
}

kernel void NBody_force(unsigned int num, global float2* pos, global float2* force) {
  const int i = get_global_id(0);
  const int tid = get_local_id(0);
  const int block_dim = get_local_size(0);

  local float2 pos_shared[256];
  float2 p = pos[hook(1, i)];
  float2 f = (float2)(0.0f, 0.0f);
  int tile = 0;

  for (int body = 0; body < num; body += block_dim, tile++) {
    pos_shared[hook(3, tid)] = pos[hook(1, tile * block_dim + tid)];
    barrier(0x01);
    for (int j = 0; j < block_dim; j++) {
      float2 pj = pos_shared[hook(3, j)];
      f += force_LJ(p, pj);
    }
    barrier(0x01);
  }
  force[hook(2, i)] = f;
}