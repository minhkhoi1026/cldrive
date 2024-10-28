//{"dt":4,"eyePosX":5,"eyePosY":6,"eyePosZ":7,"maxParticles":3,"position":0,"seed":2,"velos":1,"windDirX":8,"windDirZ":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 0x20 | 6;
kernel void rainSim(global float4* position, global float4* velos, global float4* seed, const unsigned int maxParticles, const float dt, const float eyePosX, const float eyePosY, const float eyePosZ, const float windDirX, const float windDirZ) {
  unsigned int myId = get_global_id(0);

  float4 myPos = position[hook(0, myId)].s0123;
  float3 myVelos = velos[hook(1, myId)].xyz;
  float3 eyePos = (float3)(eyePosX, eyePosY, eyePosZ);

  float dist = distance(eyePos, myPos.xyz);

  if (myPos.y <= -1.0f || dist > 50.0f) {
    myPos.xyz = seed[hook(2, myId)].xyz + eyePos;
    myPos.y += 1.f;
  }

  myPos.x += (windDirX + myVelos.x) * dt;
  myPos.y -= myVelos.y * dt;
  myPos.z += (windDirZ + myVelos.z) * dt;

  position[hook(0, myId)].s0123 = myPos;
}