//{"maxBoundGroup":2,"minBoundGroup":1,"numPoints":4,"pointPosition":0,"workGroupSize":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void getBoundsGroup(global float4* pointPosition, global float4* minBoundGroup, global float4* maxBoundGroup, const int workGroupSize, const int numPoints) {
  int p = get_global_id(0);
  float4 minBound = (float4)0x1.fffffep127f;
  float4 maxBound = (float4)-0x1.fffffep127f;
  while (p < numPoints) {
    float4 position = pointPosition[hook(0, p)];
    minBound = min(position, minBound);
    maxBound = max(position, maxBound);
    p += get_global_size(0);
  }
  minBoundGroup[hook(1, get_global_id(0))] = minBound;
  maxBoundGroup[hook(2, get_global_id(0))] = maxBound;
}