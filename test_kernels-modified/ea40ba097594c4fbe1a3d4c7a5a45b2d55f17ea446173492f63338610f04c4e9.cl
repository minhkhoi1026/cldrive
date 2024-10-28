//{"accel":1,"len":2,"pParticles":0,"tParticle":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute(global float4* pParticles, global float4* accel, const unsigned int len, global float8* tParticle) {
  unsigned int idx = get_global_id(0);

  if (idx < len) {
    float4 d = pParticles[hook(0, idx)] - (*tParticle).lo;

    float invr = rsqrt(d.x * d.x + d.y * d.y + d.z * d.z + 0.000000001);
    float invr3 = invr * invr * invr;
    float f = pParticles[hook(0, idx)].s3 * invr3;

    accel[hook(1, idx)] = (float4)(f * d.x, f * d.y, f * d.z, 0.0f);
  }
}