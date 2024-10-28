//{"dt":1,"position":0,"windDirX":2,"windDirZ":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 0x20 | 6;
kernel void fogSim(global float4* position, const float dt, const float windDirX, const float windDirZ) {
  unsigned int myId = get_global_id(0);

  float4 myPos = position[hook(0, myId)].xyzw;
  myPos.z += dt * 50;
  myPos.x += dt;

  if (fabs(fmod(myPos.z, 0.3f)) < 0.1)
    myPos.w = myPos.w < 255 ? myPos.w + 1.0 : 0;

  position[hook(0, myId)].xzw = myPos.z > 250 ? (float3)(10, -250, myPos.w) : myPos.xzw;
}