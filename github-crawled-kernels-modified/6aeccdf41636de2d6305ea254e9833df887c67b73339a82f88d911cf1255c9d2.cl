//{"ab":30,"ab7":29,"cxy":16,"fxy":15,"groupedRow":34,"groupedSum_offset":22,"groupedSum_step":21,"groupedSumptr":20,"minCos":18,"newNormals_offset":12,"newNormals_step":11,"newNormalsptr":10,"newNrmRow":24,"newPoints_offset":9,"newPoints_step":8,"newPointsptr":7,"newPtsRow":23,"newSize":13,"nrow0":27,"nrow1":28,"oldNormals_offset":5,"oldNormals_step":4,"oldNormalsptr":3,"oldPoints_offset":2,"oldPoints_step":1,"oldPointsptr":0,"oldSize":6,"poseMatrix":14,"prow0":25,"prow1":26,"reducebuf":19,"rfrom":33,"rto":32,"sqDistanceThresh":17,"upperTriangle":31}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
inline void calcAb7(global const char* oldPointsptr, int oldPoints_step, int oldPoints_offset, global const char* oldNormalsptr, int oldNormals_step, int oldNormals_offset, const int2 oldSize, global const char* newPointsptr, int newPoints_step, int newPoints_offset, global const char* newNormalsptr, int newNormals_step, int newNormals_offset, const int2 newSize, const float16 poseMatrix, const float2 fxy, const float2 cxy, const float sqDistanceThresh, const float minCos, float* ab7) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= newSize.x || y >= newSize.y)
    return;

  const float3 poseRot0 = poseMatrix.s012;
  const float3 poseRot1 = poseMatrix.s456;
  const float3 poseRot2 = poseMatrix.s89a;
  const float3 poseTrans = poseMatrix.s37b;

  const float2 oldEdge = (float2)(oldSize.x - 1, oldSize.y - 1);

  global const float4* newPtsRow = (global const float4*)(newPointsptr + newPoints_offset + y * newPoints_step);

  global const float4* newNrmRow = (global const float4*)(newNormalsptr + newNormals_offset + y * newNormals_step);

  float3 newP = newPtsRow[hook(23, x)].xyz;
  float3 newN = newNrmRow[hook(24, x)].xyz;

  if (any(isnan(newP)) || any(isnan(newN)) || any(isinf(newP)) || any(isinf(newN)))
    return;

  newP = (float3)(dot(newP, poseRot0), dot(newP, poseRot1), dot(newP, poseRot2)) + poseTrans;
  newN = (float3)(dot(newN, poseRot0), dot(newN, poseRot1), dot(newN, poseRot2));

  float2 oldCoords = (newP.xy / newP.z) * fxy + cxy;

  if (!(all(oldCoords >= 0.f) && all(oldCoords < oldEdge)))
    return;

  float3 oldP, oldN;
  float2 ip = floor(oldCoords);
  float2 t = oldCoords - ip;
  int xi = ip.x, yi = ip.y;

  global const float4* prow0 = (global const float4*)(oldPointsptr + oldPoints_offset + (yi + 0) * oldPoints_step);
  global const float4* prow1 = (global const float4*)(oldPointsptr + oldPoints_offset + (yi + 1) * oldPoints_step);
  float3 p00 = prow0[hook(25, xi + 0)].xyz;
  float3 p01 = prow0[hook(25, xi + 1)].xyz;
  float3 p10 = prow1[hook(26, xi + 0)].xyz;
  float3 p11 = prow1[hook(26, xi + 1)].xyz;

  global const float4* nrow0 = (global const float4*)(oldNormalsptr + oldNormals_offset + (yi + 0) * oldNormals_step);
  global const float4* nrow1 = (global const float4*)(oldNormalsptr + oldNormals_offset + (yi + 1) * oldNormals_step);

  float3 n00 = nrow0[hook(27, xi + 0)].xyz;
  float3 n01 = nrow0[hook(27, xi + 1)].xyz;
  float3 n10 = nrow1[hook(28, xi + 0)].xyz;
  float3 n11 = nrow1[hook(28, xi + 1)].xyz;

  float3 p0 = mix(p00, p01, t.x);
  float3 p1 = mix(p10, p11, t.x);
  oldP = mix(p0, p1, t.y);

  float3 n0 = mix(n00, n01, t.x);
  float3 n1 = mix(n10, n11, t.x);
  oldN = mix(n0, n1, t.y);

  if (any(isnan(oldP)) || any(isnan(oldN)) || any(isinf(oldP)) || any(isinf(oldN)))
    return;

  float3 diff = newP - oldP;
  if (dot(diff, diff) > sqDistanceThresh)
    return;

  if (fabs(dot(newN, oldN)) < minCos)
    return;

  float3 VxN = cross(newP, oldN);
  float ab[7] = {VxN.x, VxN.y, VxN.z, oldN.x, oldN.y, oldN.z, -dot(oldN, diff)};

  for (int i = 0; i < 7; i++)
    ab7[hook(29, i)] = ab[hook(30, i)];
}

kernel void getAb(global const char* oldPointsptr, int oldPoints_step, int oldPoints_offset, global const char* oldNormalsptr, int oldNormals_step, int oldNormals_offset, const int2 oldSize, global const char* newPointsptr, int newPoints_step, int newPoints_offset, global const char* newNormalsptr, int newNormals_step, int newNormals_offset, const int2 newSize, const float16 poseMatrix, const float2 fxy, const float2 cxy, const float sqDistanceThresh, const float minCos, local float* reducebuf, global char* groupedSumptr, int groupedSum_step, int groupedSum_offset) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= newSize.x || y >= newSize.y)
    return;

  const int gx = get_group_id(0);
  const int gy = get_group_id(1);
  const int gw = get_num_groups(0);
  const int gh = get_num_groups(1);

  const int lx = get_local_id(0);
  const int ly = get_local_id(1);
  const int lw = get_local_size(0);
  const int lh = get_local_size(1);
  const int lsz = lw * lh;
  const int lid = lx + ly * lw;

  float ab[7];
  for (int i = 0; i < 7; i++)
    ab[hook(30, i)] = 0;

  calcAb7(oldPointsptr, oldPoints_step, oldPoints_offset, oldNormalsptr, oldNormals_step, oldNormals_offset, oldSize, newPointsptr, newPoints_step, newPoints_offset, newNormalsptr, newNormals_step, newNormals_offset, newSize, poseMatrix, fxy, cxy, sqDistanceThresh, minCos, ab);

  local float* upperTriangle = reducebuf + lid * 27;

  int pos = 0;
  for (int i = 0; i < 6; i++) {
    for (int j = i; j < 7; j++) {
      upperTriangle[hook(31, pos++)] = ab[hook(30, i)] * ab[hook(30, j)];
    }
  }

  const int c = clz(lsz & -lsz);
  const int maxStep = c ? 31 - c : c;
  for (int nstep = 1; nstep <= maxStep; nstep++) {
    if (lid % (1 << nstep) == 0) {
      local float* rto = reducebuf + 27 * lid;
      local float* rfrom = reducebuf + 27 * (lid + (1 << (nstep - 1)));
      for (int i = 0; i < 27; i++)
        rto[hook(32, i)] += rfrom[hook(33, i)];
    }
    barrier(0x01);
  }

  if (lid == 0) {
    global float* groupedRow = (global float*)(groupedSumptr + groupedSum_offset + gy * groupedSum_step);

    for (int i = 0; i < 27; i++)
      groupedRow[hook(34, gx * 27 + i)] = reducebuf[hook(19, i)];
  }
}