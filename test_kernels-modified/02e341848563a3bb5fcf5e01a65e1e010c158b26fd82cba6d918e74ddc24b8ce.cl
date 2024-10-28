//{"dt":0,"pos":1,"prevPos":2,"relaxPos":4,"vel":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 VertexInterp(float isolevel, float3 p1, float3 p2, float valp1, float valp2) {
  float mu;
  float3 p;

  if ((isolevel - valp1 < 0 ? -(isolevel - valp1) : (isolevel - valp1)) < 0.00001)
    return (p1);
  if ((isolevel - valp2 < 0 ? -(isolevel - valp2) : (isolevel - valp2)) < 0.00001)
    return (p2);
  if ((valp1 - valp2 < 0 ? -(valp1 - valp2) : (valp1 - valp2)) < 0.00001)
    return (p1);

  mu = (isolevel - valp1) / (valp2 - valp1);
  p.x = p1.x + mu * (p2.x - p1.x);
  p.y = p1.y + mu * (p2.y - p1.y);
  p.z = p1.z + mu * (p2.z - p1.z);

  return (p);
}

float3 GradInterp(float isolevel, float3 g1, float3 g2, float valp1, float valp2) {
  float mu;
  float3 g;

  if ((isolevel - valp1 < 0 ? -(isolevel - valp1) : (isolevel - valp1)) < 0.00001)
    return (g1);
  if ((isolevel - valp2 < 0 ? -(isolevel - valp2) : (isolevel - valp2)) < 0.00001)
    return (g2);
  if ((valp1 - valp2 < 0 ? -(valp1 - valp2) : (valp1 - valp2)) < 0.00001)
    return (g1);

  mu = (isolevel - valp1) / (valp2 - valp1);
  g.x = g1.x + mu * (g2.x - g1.x);
  g.y = g1.y + mu * (g2.y - g1.y);
  g.z = g1.z + mu * (g2.z - g1.z);

  return (g);
}

kernel void sph_kernel_moveToRelaxPos(float dt, global float4* pos, global float4* prevPos, global float4* vel, global float4* relaxPos) {
  size_t gid = get_global_id(0);

  pos[hook(1, gid)].x = relaxPos[hook(4, gid)].x;
  pos[hook(1, gid)].y = relaxPos[hook(4, gid)].y;
  pos[hook(1, gid)].z = relaxPos[hook(4, gid)].z;

  vel[hook(3, gid)].x = (pos[hook(1, gid)].x - prevPos[hook(2, gid)].x) / dt;
  vel[hook(3, gid)].y = (pos[hook(1, gid)].y - prevPos[hook(2, gid)].y) / dt;
  vel[hook(3, gid)].z = (pos[hook(1, gid)].z - prevPos[hook(2, gid)].z) / dt;
}