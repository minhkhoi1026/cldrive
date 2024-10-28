//{"bundleWidthPower":16,"dtVal":0,"edgeCompatsInCL":8,"edgeCoulombConstant":2,"edgeCoulombDecay":19,"edgeDotsInCL":9,"edgeLaneWidth":3,"edgeListInCL":20,"edgeMaxWidth":14,"edgeMeshAccelerationsInCL":7,"edgeMeshGroupMaxCount":17,"edgeMeshGroupWeightsInCL":12,"edgeMeshVelocitiesInCL":6,"edgeMeshesInCL":5,"edgeMinWidth":15,"edgeSpringConstant":1,"edgeWeightsInCL":10,"meshCount":4,"nodeDistancesInCL":21,"useCompat":11,"useNewForce":18,"velocityDamping":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int TriIndex(unsigned int, unsigned int, unsigned int);
float Length(float4);
float2 Midpoint(float4);
float2 Reduce(float4);
float4 ProjectOnto(float4, float4);
float AngleCompat(float4, float4);
float ScaleCompat(float4, float4);
float PosCompat(float4, float4);
float VisCompat(float4, float4);
float ConnectCompat(unsigned int, global uint2*, global float*, unsigned int, unsigned int);
unsigned int TriIndex(unsigned int row, unsigned int col, unsigned int N) {
  if (row < col)
    return row * (N - 1) - (row - 1) * ((row - 1) + 1) / 2 + col - row - 1;
  else if (col < row)
    return col * (N - 1) - (col - 1) * ((col - 1) + 1) / 2 + row - col - 1;
  else
    return 0;
}

float Length(float4 edge) {
  return distance((float2)(edge.x, edge.y), (float2)(edge.z, edge.w));
}

float2 Midpoint(float4 edge) {
  float dx = edge.z - edge.x;
  float dy = edge.w - edge.y;

  return (float2)(edge.x + dx / 2.0f, edge.y + dy / 2.0f);
}

float2 Reduce(float4 edge) {
  return (float2)(edge.z - edge.x, edge.w - edge.y);
}

float4 ProjectOnto(float4 one, float4 two) {
  float2 norm = normalize(Reduce(two));
  float2 toHead = (float2)(one.x - two.x, one.y - two.y);
  float2 toTail = (float2)(one.z - two.x, one.w - two.y);
  float2 headOnOther = norm * dot(norm, toHead);
  float2 tailOnOther = norm * dot(norm, toTail);

  float2 projHead = (float2)(two.x, two.y) + headOnOther;
  float2 projTail = (float2)(two.x, two.y) + tailOnOther;

  return (float4)(projHead.x, projHead.y, projTail.x, projTail.y);
}

float AngleCompat(float4 one, float4 two) {
  float lengthOne = Length(one);
  float lengthTwo = Length(two);

  if (lengthOne == 0.0f || lengthTwo == 0.0f)
    return 0.0f;

  float compat = dot(Reduce(one), Reduce(two)) / (lengthOne * lengthTwo);
  return fabs(compat);
}

float ScaleCompat(float4 one, float4 two) {
  float lengthOne = Length(one);
  float lengthTwo = Length(two);

  float avg = (lengthOne + lengthTwo) / 2.0f;

  if (avg == 0.0f)
    return 0.0f;

  return 2.0f / (avg / min(lengthOne, lengthTwo) + max(lengthOne, lengthTwo) / avg);
}

float PosCompat(float4 one, float4 two) {
  float avg = (Length(one) + Length(two)) / 2.0f;

  if (avg == 0.0f)
    return 0.0f;

  return avg / (avg + distance(Midpoint(one), Midpoint(two)));
}

float VisCompat(float4 one, float4 two) {
  float4 I = ProjectOnto(one, two);
  float4 J = ProjectOnto(two, one);

  float Ilen = Length(I), Jlen = Length(J);

  if (Ilen == 0.0f || Jlen == 0.0f)
    return 0.0f;

  float midQmidI = distance(Midpoint(two), Midpoint(I));
  float VPQ = max(0.0f, 1.0f - (2.0f * midQmidI) / Ilen);

  float midPmidJ = distance(Midpoint(one), Midpoint(J));
  float VQP = max(0.0f, 1.0f - (2.0f * midPmidJ) / Jlen);

  return min(VPQ, VQP);
}

float ConnectCompat(unsigned int nodeCount, global uint2* edgeListInCL, global float* nodeDistancesInCL, unsigned int oneEdgeIndex, unsigned int twoEdgeIndex) {
  unsigned int oneHeadIndex = edgeListInCL[hook(20, oneEdgeIndex)].x;
  unsigned int oneTailIndex = edgeListInCL[hook(20, oneEdgeIndex)].y;
  unsigned int twoHeadIndex = edgeListInCL[hook(20, twoEdgeIndex)].x;
  unsigned int twoTailIndex = edgeListInCL[hook(20, twoEdgeIndex)].y;

  if (oneHeadIndex == twoHeadIndex || oneHeadIndex == twoTailIndex || oneTailIndex == twoHeadIndex || oneTailIndex == twoTailIndex)
    return 1.0f;

  float minPath = min(nodeDistancesInCL[hook(21, TriIndex(oneHeadIndex, twoHeadIndex, nodeCount))], min(nodeDistancesInCL[hook(21, TriIndex(oneHeadIndex, twoTailIndex, nodeCount))], min(nodeDistancesInCL[hook(21, TriIndex(oneTailIndex, twoHeadIndex, nodeCount))], nodeDistancesInCL[hook(21, TriIndex(oneTailIndex, twoTailIndex, nodeCount))])));

  return 1.0f / (minPath + 1.0f);
}

kernel void EdgeForce(float dtVal, float edgeSpringConstant, float edgeCoulombConstant, float edgeLaneWidth, unsigned int meshCount, global float2* edgeMeshesInCL, global float2* edgeMeshVelocitiesInCL, global float2* edgeMeshAccelerationsInCL, global float* edgeCompatsInCL, global float* edgeDotsInCL, global float* edgeWeightsInCL, int useCompat, global float* edgeMeshGroupWeightsInCL, float velocityDamping, float edgeMaxWidth, float edgeMinWidth, float bundleWidthPower, float edgeMeshGroupMaxCount, int useNewForce, float edgeCoulombDecay) {
  unsigned int globalPointIndex = get_global_id(0);
  unsigned int edgeCount = get_global_size(0) / meshCount;

  unsigned int edgeIndex = (unsigned int)(globalPointIndex / meshCount);
  float edgeWeight = edgeWeightsInCL[hook(10, edgeIndex)];

  float pointGroupWeight = edgeWeight;

  unsigned int edgePointIndex = globalPointIndex % meshCount;

  float2 pointPos = edgeMeshesInCL[hook(5, globalPointIndex)];
  float2 pointVelocity = edgeMeshVelocitiesInCL[hook(6, globalPointIndex)];
  float2 pointAcceleration = edgeMeshAccelerationsInCL[hook(7, globalPointIndex)];

  float2 dt = (float2)(dtVal, dtVal);

  if (edgePointIndex <= 0 || edgePointIndex >= meshCount - 1) {
    for (unsigned int otherEdgeIndex = 0; otherEdgeIndex < edgeCount; otherEdgeIndex++) {
      if (edgeIndex == otherEdgeIndex)
        continue;

      float edgeDot = edgeDotsInCL[hook(9, TriIndex(edgeIndex, otherEdgeIndex, edgeCount))];
      float otherEdgeWeight = edgeWeightsInCL[hook(10, otherEdgeIndex)];

      unsigned int globalOtherPointIndex;
      if (edgeDot >= 0.0f)
        globalOtherPointIndex = otherEdgeIndex * meshCount + edgePointIndex;
      else
        globalOtherPointIndex = otherEdgeIndex * meshCount + meshCount - 1 - edgePointIndex;

      float2 otherPointPos = edgeMeshesInCL[hook(5, globalOtherPointIndex)];

      float2 dr = otherPointPos - pointPos;
      float dist = sqrt(dr.x * dr.x + dr.y * dr.y);

      float maxGroupRadius = pow(edgeWeight, bundleWidthPower) * edgeMaxWidth;

      if (edgeDot >= 0.0f && (dist <= edgeMinWidth || dist <= maxGroupRadius))
        pointGroupWeight += otherEdgeWeight;
    }

    edgeMeshGroupWeightsInCL[hook(12, globalPointIndex)] = pointGroupWeight;

    return;
  }

  pointVelocity += pointAcceleration * dt / 2.0f;
  pointVelocity *= velocityDamping;
  pointPos += pointVelocity * dt;
  edgeMeshesInCL[hook(5, globalPointIndex)] = pointPos;

  pointAcceleration = (float2)(0.0f, 0.0f);

  float2 pointAdjPos = edgeMeshesInCL[hook(5, globalPointIndex - 1)];
  float2 dr = pointAdjPos - pointPos;
  float dist = sqrt(dr.x * dr.x + dr.y * dr.y);
  float force = edgeSpringConstant / 1000.0f * (meshCount - 1) * dist * edgeWeight;
  pointAcceleration += force * normalize(dr);

  pointAdjPos = edgeMeshesInCL[hook(5, globalPointIndex + 1)];
  dr = pointAdjPos - pointPos;
  dist = sqrt(dr.x * dr.x + dr.y * dr.y);
  force = edgeSpringConstant / 1000.0f * (meshCount - 1) * dist * edgeWeight;
  pointAcceleration += force * normalize(dr);

  edgeCoulombConstant /= sqrt((float)edgeCount);

  for (unsigned int otherEdgeIndex = 0; otherEdgeIndex < edgeCount; otherEdgeIndex++) {
    if (edgeIndex == otherEdgeIndex)
      continue;

    float otherCompat = edgeCompatsInCL[hook(8, TriIndex(edgeIndex, otherEdgeIndex, edgeCount))];
    if (useCompat && otherCompat <= 0.05)
      continue;

    float edgeDot = edgeDotsInCL[hook(9, TriIndex(edgeIndex, otherEdgeIndex, edgeCount))];
    float otherEdgeWeight = edgeWeightsInCL[hook(10, otherEdgeIndex)];

    unsigned int globalOtherPointIndex;
    if (edgeDot >= 0.0f)
      globalOtherPointIndex = otherEdgeIndex * meshCount + edgePointIndex;
    else
      globalOtherPointIndex = otherEdgeIndex * meshCount + meshCount - 1 - edgePointIndex;

    float2 otherPointPos;

    if (edgeDot >= 0.0f)
      otherPointPos = edgeMeshesInCL[hook(5, globalOtherPointIndex)];

    else {
      float2 tangent = normalize(edgeMeshesInCL[hook(5, globalOtherPointIndex + 1)] - edgeMeshesInCL[hook(5, globalOtherPointIndex - 1)]);
      float2 normal = (float2)(-tangent.y, tangent.x);
      otherPointPos = edgeMeshesInCL[hook(5, globalOtherPointIndex)] + normal * edgeLaneWidth;
    }

    dr = otherPointPos - pointPos;
    dist = sqrt(dr.x * dr.x + dr.y * dr.y);

    float maxGroupRadius = pow(edgeWeight, bundleWidthPower) * edgeMaxWidth;

    if (edgeDot >= 0.0f && (dist <= edgeMinWidth || dist <= maxGroupRadius))
      pointGroupWeight += otherEdgeWeight;

    if (!useNewForce)
      force = edgeCoulombConstant * 30.0f / (meshCount - 1) / (dist + 0.01f);

    else
      force = 4.0f * 10000.0f / (meshCount - 1) * edgeCoulombDecay * edgeCoulombConstant * dist / (3.1415926f * pown(edgeCoulombDecay * edgeCoulombDecay + dist * dist, 2));
    force *= otherEdgeWeight;

    if (useCompat)
      force *= otherCompat;

    pointAcceleration += force * normalize(dr);
  }

  pointVelocity += pointAcceleration * dt / 2.0f;
  edgeMeshVelocitiesInCL[hook(6, globalPointIndex)] = pointVelocity;
  edgeMeshAccelerationsInCL[hook(7, globalPointIndex)] = pointAcceleration;

  edgeMeshGroupWeightsInCL[hook(12, globalPointIndex)] = pointGroupWeight;
}