//{"damping":5,"deltaTime":4,"newPos":0,"newVel":1,"numBodies":7,"oldPos":2,"oldVel":3,"positions":9,"sharedPos":8,"softeningSquared":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 bodyBodyInteraction(float3 ai, float4 bi, float4 bj, float softeningSquared) {
  float3 r;

  r.x = bi.x - bj.x;
  r.y = bi.y - bj.y;
  r.z = bi.z - bj.z;

  float distSqr = r.x * r.x + r.y * r.y + r.z * r.z;
  distSqr += softeningSquared;

  float invDist = rsqrt((float)distSqr);
  float invDistCube = invDist * invDist * invDist;

  float s = bj.w * invDistCube;

  ai.x += r.x * s;
  ai.y += r.y * s;
  ai.z += r.z * s;

  return ai;
}

float3 gravitation(float4 myPos, float3 accel, float softeningSquared, local float4* sharedPos) {
  unsigned long i = 0;
  int blockDimx = get_local_size(0);
  for (unsigned int counter = 0; counter < blockDimx;) {
    accel = bodyBodyInteraction(accel, sharedPos[hook(8, i++ + mul24((unsigned int)get_local_size(0), (unsigned int)get_local_id(1)))], myPos, softeningSquared);
    counter++;

    accel = bodyBodyInteraction(accel, sharedPos[hook(8, i++ + mul24((unsigned int)get_local_size(0), (unsigned int)get_local_id(1)))], myPos, softeningSquared);
    counter++;

    accel = bodyBodyInteraction(accel, sharedPos[hook(8, i++ + mul24((unsigned int)get_local_size(0), (unsigned int)get_local_id(1)))], myPos, softeningSquared);
    accel = bodyBodyInteraction(accel, sharedPos[hook(8, i++ + mul24((unsigned int)get_local_size(0), (unsigned int)get_local_id(1)))], myPos, softeningSquared);
    counter += 2;
  }

  return accel;
}

float3 computeBodyAccel_MT(float4 bodyPos, global float4* positions, int numBodies, float softeningSquared, local float4* sharedPos) {
  float3 acc = {0.0f, 0.0f, 0.0f};

  unsigned int threadIdxx = get_local_id(0);
  unsigned int threadIdxy = get_local_id(1);
  unsigned int blockIdxx = get_group_id(0);
  unsigned int blockIdxy = get_group_id(1);
  unsigned int gridDimx = get_num_groups(0);
  unsigned int blockDimx = get_local_size(0);
  unsigned int blockDimy = get_local_size(1);
  unsigned int numTiles = numBodies / mul24(blockDimx, blockDimy);

  for (unsigned int tile = blockIdxy; tile < numTiles + blockIdxy; tile++) {
    sharedPos[hook(8, threadIdxx + blockDimx * threadIdxy)] = positions[hook(9, (((blockIdxx + mul24(blockDimy, tile) + threadIdxy) < gridDimx) ? (blockIdxx + mul24(blockDimy, tile) + threadIdxy) : (blockIdxx + mul24(blockDimy, tile) + threadIdxy - gridDimx)) * blockDimx + threadIdxx)];

    barrier(0x01);

    acc = gravitation(bodyPos, acc, softeningSquared, sharedPos);

    barrier(0x01);
  }
  sharedPos[hook(8, threadIdxx + mul24((unsigned int)get_local_size(0), (unsigned int)threadIdxy))].x = acc.x;
  sharedPos[hook(8, threadIdxx + mul24((unsigned int)get_local_size(0), (unsigned int)threadIdxy))].y = acc.y;
  sharedPos[hook(8, threadIdxx + mul24((unsigned int)get_local_size(0), (unsigned int)threadIdxy))].z = acc.z;

  barrier(0x01);

  if (get_local_id(0) == 0) {
    for (unsigned int i = 1; i < blockDimy; i++) {
      acc.x += sharedPos[hook(8, threadIdxx + mul24((unsigned int)get_local_size(0), (unsigned int)i))].x;
      acc.y += sharedPos[hook(8, threadIdxx + mul24((unsigned int)get_local_size(0), (unsigned int)i))].y;
      acc.z += sharedPos[hook(8, threadIdxx + mul24((unsigned int)get_local_size(0), (unsigned int)i))].z;
    }
  }

  return acc;
}

float3 computeBodyAccel_noMT(float4 bodyPos, global float4* positions, int numBodies, float softeningSquared, local float4* sharedPos) {
  float3 acc = {0.0f, 0.0f, 0.0f};

  unsigned int threadIdxx = get_local_id(0);
  unsigned int threadIdxy = get_local_id(1);
  unsigned int blockIdxx = get_group_id(0);
  unsigned int blockIdxy = get_group_id(1);
  unsigned int gridDimx = get_num_groups(0);
  unsigned int blockDimx = get_local_size(0);
  unsigned int blockDimy = get_local_size(1);
  unsigned int numTiles = numBodies / mul24(blockDimx, blockDimy);

  for (unsigned int tile = blockIdxy; tile < numTiles + blockIdxy; tile++) {
    sharedPos[hook(8, threadIdxx + mul24(blockDimx, threadIdxy))] = positions[hook(9, (((blockIdxx + tile) < gridDimx) ? (blockIdxx + tile) : (blockIdxx + tile - gridDimx)) * blockDimx + threadIdxx)];

    barrier(0x01);

    acc = gravitation(bodyPos, acc, softeningSquared, sharedPos);

    barrier(0x01);
  }
  return acc;
}

kernel void integrateBodies_MT(global float4* newPos, global float4* newVel, global float4* oldPos, global float4* oldVel, float deltaTime, float damping, float softeningSquared, int numBodies, local float4* sharedPos) {
  unsigned int threadIdxx = get_local_id(0);
  unsigned int threadIdxy = get_local_id(1);
  unsigned int blockIdxx = get_group_id(0);
  unsigned int blockIdxy = get_group_id(1);
  unsigned int gridDimx = get_num_groups(0);
  unsigned int blockDimx = get_local_size(0);
  unsigned int blockDimy = get_local_size(1);

  unsigned int index = mul24(blockIdxx, blockDimx) + threadIdxx;
  float4 pos = oldPos[hook(2, index)];
  float3 accel = computeBodyAccel_MT(pos, oldPos, numBodies, softeningSquared, sharedPos);

  float4 vel = oldVel[hook(3, index)];

  vel.x += accel.x * deltaTime;
  vel.y += accel.y * deltaTime;
  vel.z += accel.z * deltaTime;

  vel.x *= damping;
  vel.y *= damping;
  vel.z *= damping;

  pos.x += vel.x * deltaTime;
  pos.y += vel.y * deltaTime;
  pos.z += vel.z * deltaTime;

  newPos[hook(0, index)] = pos;
  newVel[hook(1, index)] = vel;
}