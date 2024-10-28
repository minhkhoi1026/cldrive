//{"accel":0,"len1":2,"len2":3,"t":4,"tParticles":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update(global float4* accel, global float8* tParticles, const int len1, const int len2, const float t) {
  int i = get_global_id(0);

  if (get_global_id(1) == 0 && i < len1) {
    float4 v = tParticles[hook(1, i)].hi;

    int idx = i * len2 + 0;
    tParticles[hook(1, i)].s0 += v.x * t + 0.5 * accel[hook(0, idx)].x * t * t;
    tParticles[hook(1, i)].s1 += v.y * t + 0.5 * accel[hook(0, idx)].y * t * t;
    tParticles[hook(1, i)].s2 += v.z * t + 0.5 * accel[hook(0, idx)].z * t * t;

    tParticles[hook(1, i)].s4 += accel[hook(0, idx)].x * t;
    tParticles[hook(1, i)].s5 += accel[hook(0, idx)].y * t;
    tParticles[hook(1, i)].s6 += accel[hook(0, idx)].z * t;
  }
}