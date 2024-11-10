//{"deltaTime":3,"epsSqr":4,"newPosition":5,"newVelocity":6,"numBodies":2,"pos":0,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_sim(global float4* pos, global float4* vel, int numBodies, float deltaTime, float epsSqr, global float4* newPosition, global float4* newVelocity) {
  unsigned int gid = get_global_id(0);
  float4 myPos = pos[hook(0, gid)];
  float4 acc = (float4)0.0f;

  int i = 0;
  for (; (i + 8) < numBodies;) {
    for (int j = 0; j < 8; j++, i++) {
      float4 p = pos[hook(0, i)];
      float4 r;
      r.xyz = p.xyz - myPos.xyz;
      float distSqr = r.x * r.x + r.y * r.y + r.z * r.z;

      float invDist = 1.0f / sqrt(distSqr + epsSqr);
      float invDistCube = invDist * invDist * invDist;
      float s = p.w * invDistCube;

      acc.xyz += s * r.xyz;
    }
  }
  for (; i < numBodies; i++) {
    float4 p = pos[hook(0, i)];

    float4 r;
    r.xyz = p.xyz - myPos.xyz;
    float distSqr = r.x * r.x + r.y * r.y + r.z * r.z;

    float invDist = 1.0f / sqrt(distSqr + epsSqr);
    float invDistCube = invDist * invDist * invDist;
    float s = p.w * invDistCube;

    acc.xyz += s * r.xyz;
  }

  float4 oldVel = vel[hook(1, gid)];

  float4 newPos;
  newPos.xyz = myPos.xyz + oldVel.xyz * deltaTime + acc.xyz * 0.5f * deltaTime * deltaTime;
  newPos.w = myPos.w;

  float4 newVel;
  newVel.xyz = oldVel.xyz + acc.xyz * deltaTime;
  newVel.w = oldVel.w;

  newPosition[hook(5, gid)] = newPos;
  newVelocity[hook(6, gid)] = newVel;
}