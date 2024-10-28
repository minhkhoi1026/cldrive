//{"d":10,"h":9,"indexBuffer":4,"maxBound":6,"minBound":5,"nDim":11,"pointColor":2,"pointPosition":0,"pointSize":1,"vertexBuffer":3,"viewBound":7,"viewOffset":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void createVertexBufferPoints(global float4* pointPosition, global float* pointSize, global unsigned int* pointColor, global union BufferType* vertexBuffer, global unsigned int* indexBuffer, float4 minBound, float4 maxBound, float4 viewBound, float4 viewOffset, float h, global unsigned int* d, int nDim) {
  const int p = get_global_id(0);
  const float4 pos = pointPosition[hook(0, p)];
  const unsigned int rgba = pointColor[hook(2, p)];
  const float4 bound = maxBound - minBound;
  const float4 vec = (pos - minBound) / bound * viewBound + viewOffset;
  const float3 proj = (float3)(vec.x * (d[hook(10, 0)] == 0) + vec.y * (d[hook(10, 0)] == 1) + vec.z * (d[hook(10, 0)] == 2) + vec.w * (d[hook(10, 0)] == 3), vec.x * (d[hook(10, 1)] == 0) + vec.y * (d[hook(10, 1)] == 1) + vec.z * (d[hook(10, 1)] == 2) + vec.w * (d[hook(10, 1)] == 3), vec.x * (d[hook(10, 2)] == 0) + vec.y * (d[hook(10, 2)] == 1) + vec.z * (d[hook(10, 2)] == 2) + vec.w * (d[hook(10, 2)] == 3));
  h *= pointSize[hook(1, p)];

  if (nDim == 2) {
    global union BufferType* v = &vertexBuffer[hook(3, 4 * p)];
    (*v++).f = proj.x;
    (*v++).f = proj.y;
    (*v++).f = h;
    (*v++).u = rgba;
    indexBuffer[hook(4, p)] = p;
  } else if (nDim == 3) {
    global union BufferType* v = &vertexBuffer[hook(3, 5 * p)];
    (*v++).f = proj.x;
    (*v++).f = proj.y;
    (*v++).f = proj.z;
    (*v++).f = h;
    (*v++).u = rgba;
    indexBuffer[hook(4, p)] = p;
  }
}