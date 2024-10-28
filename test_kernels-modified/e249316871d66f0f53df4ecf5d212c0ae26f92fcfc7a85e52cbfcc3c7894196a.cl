//{"edgeListInCL":3,"edgeMeshesInCL":2,"gaussianKernel":5,"meshCount":0,"nodeDistancesInCL":4,"originalEdgeMeshesInCL":1}
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
  unsigned int oneHeadIndex = edgeListInCL[hook(3, oneEdgeIndex)].x;
  unsigned int oneTailIndex = edgeListInCL[hook(3, oneEdgeIndex)].y;
  unsigned int twoHeadIndex = edgeListInCL[hook(3, twoEdgeIndex)].x;
  unsigned int twoTailIndex = edgeListInCL[hook(3, twoEdgeIndex)].y;

  if (oneHeadIndex == twoHeadIndex || oneHeadIndex == twoTailIndex || oneTailIndex == twoHeadIndex || oneTailIndex == twoTailIndex)
    return 1.0f;

  float minPath = min(nodeDistancesInCL[hook(4, TriIndex(oneHeadIndex, twoHeadIndex, nodeCount))], min(nodeDistancesInCL[hook(4, TriIndex(oneHeadIndex, twoTailIndex, nodeCount))], min(nodeDistancesInCL[hook(4, TriIndex(oneTailIndex, twoHeadIndex, nodeCount))], nodeDistancesInCL[hook(4, TriIndex(oneTailIndex, twoTailIndex, nodeCount))])));

  return 1.0f / (minPath + 1.0f);
}

kernel void EdgeSmooth(unsigned int meshCount, global float2* originalEdgeMeshesInCL, global float2* edgeMeshesInCL) {
  const unsigned int kernelSize = 3;

  const float gaussianKernel[] = {0.10468, 0.139936, 0.166874, 0.177019, 0.166874, 0.139936, 0.10468};

  unsigned int globalPointIndex = get_global_id(0);

  unsigned int edgePointIndex = globalPointIndex % meshCount;
  if (edgePointIndex <= 0 || edgePointIndex >= meshCount - 1) {
    edgeMeshesInCL[hook(2, globalPointIndex)] = originalEdgeMeshesInCL[hook(1, globalPointIndex)];
    return;
  }

  float2 smoothedPointPos = (float2)(0.0f, 0.0f);

  for (unsigned int kernelIndex = 0; kernelIndex <= kernelSize * 2 + 1; kernelIndex++) {
    int smoothPointEdgeIndex = (int)edgePointIndex + (int)kernelIndex - (int)kernelSize;
    if (smoothPointEdgeIndex < 0)
      smoothPointEdgeIndex = 0;
    else if ((unsigned int)smoothPointEdgeIndex >= meshCount)
      smoothPointEdgeIndex = meshCount - 1;

    unsigned int smoothPointGlobalIndex = globalPointIndex - edgePointIndex + smoothPointEdgeIndex;

    smoothedPointPos += gaussianKernel[hook(5, kernelIndex)] * originalEdgeMeshesInCL[hook(1, smoothPointGlobalIndex)];
  }

  edgeMeshesInCL[hook(2, globalPointIndex)] = smoothedPointPos;
}