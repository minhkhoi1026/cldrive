//{"accel":2,"len1":3,"len2":4,"pParticles":1,"tParticles":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute(global float8* tParticles, global float4* pParticles, global float4* accel, const unsigned int len1, const unsigned int len2) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  if (i < len1 && j < len2) {
    float4 d = pParticles[hook(1, j)] - tParticles[hook(0, i)].lo;

    float invr = rsqrt(d.x * d.x + d.y * d.y + d.z * d.z + 0.000000001);
    float invr3 = invr * invr * invr;
    float f = pParticles[hook(1, j)].s3 * invr3;

    accel[hook(2, i * len2 + j)] = (float4)(f * d.x, f * d.y, f * d.z, 0.0);
  }
}