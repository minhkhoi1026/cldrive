//{"d":10,"indexBuffer":5,"maxBound":7,"minBound":6,"nDim":11,"pointPosition":0,"springColor":1,"springPointIndex1":2,"springPointIndex2":3,"vertexBuffer":4,"viewBound":8,"viewOffset":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void createVertexBufferEdges(global float4* pointPosition, global unsigned int* springColor, global unsigned int* springPointIndex1, global unsigned int* springPointIndex2, global union BufferType* vertexBuffer, global unsigned int* indexBuffer, float4 minBound, float4 maxBound, float4 viewBound, float4 viewOffset, global unsigned int* d, int nDim) {
  const int s = get_global_id(0);
  const int p1 = springPointIndex1[hook(2, s)];
  const int p2 = springPointIndex2[hook(3, s)];
  const unsigned int rgba = springColor[hook(1, s)];
  const float4 pos1 = pointPosition[hook(0, p1)];
  const float4 int2 = pointPosition[hook(0, p2)];
  const float4 bound = maxBound - minBound;
  const float4 vec1 = (pos1 - minBound) / bound * viewBound + viewOffset;
  const float4 float2 = (int2 - minBound) / bound * viewBound + viewOffset;
  const float3 proj1 = (float3)(vec1.x * (d[hook(10, 0)] == 0) + vec1.y * (d[hook(10, 0)] == 1) + vec1.z * (d[hook(10, 0)] == 2) + vec1.w * (d[hook(10, 0)] == 3), vec1.x * (d[hook(10, 1)] == 0) + vec1.y * (d[hook(10, 1)] == 1) + vec1.z * (d[hook(10, 1)] == 2) + vec1.w * (d[hook(10, 1)] == 3), vec1.x * (d[hook(10, 2)] == 0) + vec1.y * (d[hook(10, 2)] == 1) + vec1.z * (d[hook(10, 2)] == 2) + vec1.w * (d[hook(10, 2)] == 3));
  const float3 proj2 = (float3)(float2.x * (d[hook(10, 0)] == 0) + float2.y * (d[hook(10, 0)] == 1) + float2.z * (d[hook(10, 0)] == 2) + float2.w * (d[hook(10, 0)] == 3), float2.x * (d[hook(10, 1)] == 0) + float2.y * (d[hook(10, 1)] == 1) + float2.z * (d[hook(10, 1)] == 2) + float2.w * (d[hook(10, 1)] == 3), float2.x * (d[hook(10, 2)] == 0) + float2.y * (d[hook(10, 2)] == 1) + float2.z * (d[hook(10, 2)] == 2) + float2.w * (d[hook(10, 2)] == 3));

  if (nDim == 2) {
    float x1 = proj1.x, y1 = proj1.y;
    float x2 = proj2.x, y2 = proj2.y;
    global union BufferType* v = &vertexBuffer[hook(4, 6 * s)];
    (*v++).f = x1;
    (*v++).f = y1;
    (*v++).u = rgba;
    (*v++).f = x2;
    (*v++).f = y2;
    (*v++).u = rgba;
    global unsigned int* i = &indexBuffer[hook(5, 2 * s)];
    unsigned int vert = 2 * s;
    *(i++) = vert + 0;
    *(i++) = vert + 1;
  } else if (nDim == 3) {
    float x1 = proj1.x, y1 = proj1.y, z1 = proj1.z;
    float x2 = proj2.x, y2 = proj2.y, z2 = proj2.z;
    global union BufferType* v = &vertexBuffer[hook(4, 8 * s)];
    (*v++).f = x1;
    (*v++).f = y1;
    (*v++).f = z1;
    (*v++).u = rgba;
    (*v++).f = x2;
    (*v++).f = y2;
    (*v++).f = z2;
    (*v++).u = rgba;
    global unsigned int* i = &indexBuffer[hook(5, 2 * s)];
    unsigned int vert = 2 * s;
    *(i++) = vert + 0;
    *(i++) = vert + 1;
  }
}