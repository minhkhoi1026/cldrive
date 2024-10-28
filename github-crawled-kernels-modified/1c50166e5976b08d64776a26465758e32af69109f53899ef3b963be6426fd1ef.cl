//{"partIdx":2,"pos":0,"sortedPos":3,"sortedVel":4,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_sortPostPass(global float4* pos, global float4* vel, global uint2* partIdx, global float4* sortedPos, global float4* sortedVel) {
  unsigned int gid = get_global_id(0);

  int particleID = partIdx[hook(2, gid)].y;

  float4 tempPos = pos[hook(0, particleID)];

  sortedPos[hook(3, gid)].x = tempPos.x;
  sortedPos[hook(3, gid)].y = tempPos.y;
  sortedPos[hook(3, gid)].z = tempPos.z;
  sortedPos[hook(3, gid)].w = tempPos.w;

  float4 tempVel = vel[hook(1, particleID)];

  sortedVel[hook(4, gid)].x = tempVel.x;
  sortedVel[hook(4, gid)].y = tempVel.y;
  sortedVel[hook(4, gid)].z = tempVel.z;
  sortedVel[hook(4, gid)].w = tempVel.w;
}