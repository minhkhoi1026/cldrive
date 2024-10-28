//{"deltaTime":3,"epsSqr":4,"localPos":5,"newPosition":6,"newVelocity":7,"numBodies":2,"pos":0,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_sim(global float4* pos, global float4* vel, int numBodies, float deltaTime, float epsSqr, local float4* localPos, global float4* newPosition, global float4* newVelocity) {
  unsigned int tid = get_local_id(0);
  unsigned int gid = get_global_id(0);
  unsigned int localSize = get_local_size(0);

  unsigned int numTiles = numBodies / localSize;

  float4 myPos = pos[hook(0, gid)];
  float4 acc = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (int i = 0; i < numTiles; ++i) {
    int idx = i * localSize + tid;
    localPos[hook(5, tid)] = pos[hook(0, idx)];

    barrier(0x01);

    for (int j = 0; j < localSize; ++j) {
      float4 r = localPos[hook(5, j)] - myPos;
      float distSqr = r.x * r.x + r.y * r.y + r.z * r.z;
      float invDist = 1.0f / sqrt(distSqr + epsSqr);
      float invDistCube = invDist * invDist * invDist;
      float s = localPos[hook(5, j)].w * invDistCube;

      acc += s * r;
    }

    barrier(0x01);
  }

  float4 oldVel = vel[hook(1, gid)];

  float4 newPos = myPos + oldVel * deltaTime + acc * 0.5f * deltaTime * deltaTime;
  newPos.w = myPos.w;
  float4 newVel = oldVel + acc * deltaTime;

  newPosition[hook(6, gid)] = newPos;
  newVelocity[hook(7, gid)] = newVel;
}