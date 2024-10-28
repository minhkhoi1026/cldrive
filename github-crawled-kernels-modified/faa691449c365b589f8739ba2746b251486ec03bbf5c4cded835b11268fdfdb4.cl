//{"accel":0,"t":2,"tParticle":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update(global float4* accel, global float8* tParticle, const float t) {
  if (get_global_id(0) == 0) {
    float4 v = (*tParticle).hi;
    (*tParticle).s0 += v.x * t + 0.5 * accel[hook(0, 0)].x * t * t;
    (*tParticle).s1 += v.y * t + 0.5 * accel[hook(0, 0)].y * t * t;
    (*tParticle).s2 += v.z * t + 0.5 * accel[hook(0, 0)].z * t * t;

    (*tParticle).s4 += accel[hook(0, 0)].x * t;
    (*tParticle).s5 += accel[hook(0, 0)].y * t;
    (*tParticle).s6 += accel[hook(0, 0)].z * t;
  }
}