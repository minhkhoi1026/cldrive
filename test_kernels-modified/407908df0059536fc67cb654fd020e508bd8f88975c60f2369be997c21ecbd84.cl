//{"cellSize":1,"density":13,"dt":2,"dt2":3,"kLinearViscocity":7,"kNearNorm":4,"kNorm":5,"kQuadraticViscocity":8,"kSurfaceTension":6,"m":0,"maxNeighbors":9,"nearDensity":14,"nearPressure":16,"neighborMap":12,"pos":10,"pressure":15,"relaxPos":17,"vel":11}
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

kernel void sph_kernel_calcRelaxPos(float m, float cellSize, float dt, float dt2, float kNearNorm, float kNorm, float kSurfaceTension, float kLinearViscocity, float kQuadraticViscocity, int maxNeighbors, global float4* pos, global float4* vel, global int* neighborMap, global float* density, global float* nearDensity, global float* pressure, global float* nearPressure, global float4* relaxPos) {
  size_t gid = get_global_id(0);

  float3 myPos = pos[hook(10, gid)].xyz;
  float3 myVel = vel[hook(11, gid)].xyz;

  float x = myPos.x;
  float y = myPos.y;
  float z = myPos.z;

  int i;
  float3 posJ;
  float3 velJ;

  for (i = 0; i < maxNeighbors; i++) {
    int nID = neighborMap[hook(12, maxNeighbors * gid + i)];
    if ((nID >= 0) && ((unsigned int)nID == gid))
      continue;

    posJ = pos[hook(10, nID)].xyz;

    float3 diff = posJ - myPos;
    float r = length(diff);

    float dx = diff.x;
    float dy = diff.y;
    float dz = diff.z;

    float a = 1 - r / cellSize;

    float d = dt2 * ((nearPressure[hook(16, gid)] + nearPressure[hook(16, nID)]) * a * a * a * kNearNorm + (pressure[hook(15, gid)] + pressure[hook(15, nID)]) * a * a * kNorm) / 2.0;

    x -= d * dx / (r * m);
    y -= d * dy / (r * m);
    z -= d * dz / (r * m);

    x += (kSurfaceTension / m) * m * a * a * kNorm * dx;
    y += (kSurfaceTension / m) * m * a * a * kNorm * dy;
    z += (kSurfaceTension / m) * m * a * a * kNorm * dz;

    velJ = vel[hook(11, nID)].xyz;

    float3 diffV = myVel - velJ;
    float u = diffV.x * dx + diffV.y * dy + diffV.z * dz;

    if (u > 0) {
      u /= r;

      float a = 1 - r / cellSize;

      float I = .5 * dt * a * (kLinearViscocity * u + kQuadraticViscocity * u * u);

      x -= I * dx * dt;
      y -= I * dy * dt;
      z -= I * dz * dt;
    }
  }

  relaxPos[hook(17, gid)].x = x;
  relaxPos[hook(17, gid)].y = y;
  relaxPos[hook(17, gid)].z = z;
}