//{"curPos":0,"curVel":1,"deltaTime":3,"epsSqr":4,"localPos":5,"numBodies":2,"nxtPos":6,"nxtVel":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_kernel(global float* curPos, global float* curVel, int numBodies, float deltaTime, int epsSqr, local float* localPos, global float* nxtPos, global float* nxtVel) {
  unsigned int tid = get_local_id(0);
  unsigned int gid = get_global_id(0);
  unsigned int localSize = get_local_size(0);

  unsigned int numTiles = numBodies / localSize;

  float4 myPos = (float4)(curPos[hook(0, 4 * gid + 0)], curPos[hook(0, 4 * gid + 1)], curPos[hook(0, 4 * gid + 2)], curPos[hook(0, 4 * gid + 3)]);
  float4 acc = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (int i = 0; i < numTiles; ++i) {
    int idx = i * localSize + tid;
    for (int k = 0; k < 4; k++) {
      localPos[hook(5, 4 * tid + k)] = curPos[hook(0, 4 * idx + k)];
    }

    barrier(0x01);

    for (int j = 0; j < localSize; ++j) {
      float4 aLocalPos = (float4)(localPos[hook(5, 4 * j + 0)], localPos[hook(5, 4 * j + 1)], localPos[hook(5, 4 * j + 2)], localPos[hook(5, 4 * j + 3)]);
      float4 r = aLocalPos - myPos;
      float distSqr = r.x * r.x + r.y * r.y + r.z * r.z;
      float invDist = 1.0f / sqrt(distSqr + epsSqr);
      float invDistCube = invDist * invDist * invDist;
      float s = aLocalPos.w * invDistCube;

      acc += s * r;
    }

    barrier(0x01);
  }

  float4 oldVel = (float4)(curVel[hook(1, 4 * gid + 0)], curVel[hook(1, 4 * gid + 1)], curVel[hook(1, 4 * gid + 2)], curVel[hook(1, 4 * gid + 3)]);

  float4 newPos = myPos + oldVel * deltaTime + acc * 0.5f * deltaTime * deltaTime;
  newPos.w = myPos.w;
  float4 newVel = oldVel + acc * deltaTime;

  if (newPos.x > 1.0f || newPos.x < -1.0f || newPos.y > 1.0f || newPos.y < -1.0f || newPos.z > 1.0f || newPos.z < -1.0f) {
    float rand = (1.0f * gid) / numBodies;
    float r = 0.05f * rand;
    float theta = rand;
    float phi = 2 * rand;
    newPos.x = r * sinpi(theta) * cospi(phi);
    newPos.y = r * sinpi(theta) * sinpi(phi);
    newPos.z = r * cospi(theta);
    newVel.x = 0.0f;
    newVel.y = 0.0f;
    newVel.z = 0.0f;
  }

  nxtPos[hook(6, 4 * gid + 0)] = newPos.x;
  nxtPos[hook(6, 4 * gid + 1)] = newPos.y;
  nxtPos[hook(6, 4 * gid + 2)] = newPos.z;
  nxtPos[hook(6, 4 * gid + 3)] = newPos.w;

  nxtVel[hook(7, 4 * gid + 0)] = newVel.x;
  nxtVel[hook(7, 4 * gid + 1)] = newVel.y;
  nxtVel[hook(7, 4 * gid + 2)] = newVel.z;
  nxtVel[hook(7, 4 * gid + 3)] = newVel.w;
}