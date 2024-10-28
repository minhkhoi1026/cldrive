//{"partIdx":2,"pos":0,"prevPos":5,"sortedPos":3,"sortedPrevPos":6,"sortedVel":4,"vel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_sortPostPass(global float4* pos, global float4* vel, global uint2* partIdx, global float4* sortedPos, global float4* sortedVel, global float4* prevPos, global float4* sortedPrevPos) {
  unsigned int gid = get_global_id(0);

  int particleID = partIdx[hook(2, gid)].y;

  sortedPos[hook(3, gid)].x = pos[hook(0, particleID)].x;
  sortedPos[hook(3, gid)].y = pos[hook(0, particleID)].y;
  sortedPos[hook(3, gid)].z = pos[hook(0, particleID)].z;
  sortedPos[hook(3, gid)].w = pos[hook(0, particleID)].w;

  sortedVel[hook(4, gid)].x = vel[hook(1, particleID)].x;
  sortedVel[hook(4, gid)].y = vel[hook(1, particleID)].y;
  sortedVel[hook(4, gid)].z = vel[hook(1, particleID)].z;
  sortedVel[hook(4, gid)].w = vel[hook(1, particleID)].w;

  sortedPrevPos[hook(6, gid)].x = prevPos[hook(5, particleID)].x;
  sortedPrevPos[hook(6, gid)].y = prevPos[hook(5, particleID)].y;
  sortedPrevPos[hook(6, gid)].z = prevPos[hook(5, particleID)].z;
  sortedPrevPos[hook(6, gid)].w = prevPos[hook(5, particleID)].w;

  barrier(0x02);

  pos[hook(0, gid)].x = sortedPos[hook(3, gid)].x;
  pos[hook(0, gid)].y = sortedPos[hook(3, gid)].y;
  pos[hook(0, gid)].z = sortedPos[hook(3, gid)].z;
  pos[hook(0, gid)].w = sortedPos[hook(3, gid)].w;

  vel[hook(1, gid)].x = sortedVel[hook(4, gid)].x;
  vel[hook(1, gid)].y = sortedVel[hook(4, gid)].y;
  vel[hook(1, gid)].z = sortedVel[hook(4, gid)].z;
  vel[hook(1, gid)].w = sortedVel[hook(4, gid)].w;

  pos[hook(0, particleID)].x = sortedPos[hook(3, particleID)].x;
  pos[hook(0, particleID)].y = sortedPos[hook(3, particleID)].y;
  pos[hook(0, particleID)].z = sortedPos[hook(3, particleID)].z;
  pos[hook(0, particleID)].w = sortedPos[hook(3, particleID)].w;

  barrier(0x02);

  vel[hook(1, particleID)].x = sortedVel[hook(4, particleID)].x;
  vel[hook(1, particleID)].y = sortedVel[hook(4, particleID)].y;
  vel[hook(1, particleID)].z = sortedVel[hook(4, particleID)].z;
  vel[hook(1, particleID)].w = sortedVel[hook(4, particleID)].w;
}