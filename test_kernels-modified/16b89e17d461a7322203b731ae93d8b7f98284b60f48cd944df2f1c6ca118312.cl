//{"delta":4,"numBodies":3,"positionsIn":0,"positionsOut":1,"scratch":6,"softening":5,"velocities":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 computeForce(float4 ipos, float4 jpos, float softening) {
  float4 d = jpos - ipos;
  d.w = 0;
  float distSq = d.x * d.x + d.y * d.y + d.z * d.z + softening * softening;
  float invdist = native_rsqrt(distSq);
  float coeff = jpos.w * (invdist * invdist * invdist);
  return coeff * d;
}

kernel void nbody(global float4* positionsIn, global float4* positionsOut, global float4* velocities, const unsigned int numBodies, const float delta, const float softening) {
  unsigned int i = get_global_id(0);
  unsigned int lid = get_local_id(0);
  float4 ipos = positionsIn[hook(0, i)];

  unsigned int wgsize = get_local_size(0);

  local float4 scratch[1024];

  float4 force = 0.f;
  for (unsigned int j = 0; j < numBodies; j += wgsize) {
    barrier(0x01);
    scratch[hook(6, lid)] = positionsIn[hook(0, j + lid)];
    barrier(0x01);

    for (unsigned int k = 0; k < wgsize; k++) {
      force += computeForce(ipos, scratch[hook(6, k)], softening);
    }
  }

  float4 velocity = velocities[hook(2, i)];
  velocity += force * delta;
  velocities[hook(2, i)] = velocity;

  positionsOut[hook(1, i)] = ipos + velocity * delta;
}