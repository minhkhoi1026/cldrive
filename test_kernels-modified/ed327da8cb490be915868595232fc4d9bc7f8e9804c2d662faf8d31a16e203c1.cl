//{"bounds":2,"maxBoundGroup":1,"minBoundGroup":0,"numWorkItems":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
union BufferType {
  float f;
  unsigned int u;
};

kernel void getBoundsGather(global float4* minBoundGroup, global float4* maxBoundGroup, global float4* bounds, const int numWorkItems) {
  float4 minBound = (float4)0x1.fffffep127f;
  float4 maxBound = (float4)-0x1.fffffep127f;
  for (int wi = 0; wi < numWorkItems; wi++) {
    minBound = min(minBoundGroup[hook(0, wi)], minBound);
    maxBound = max(maxBoundGroup[hook(1, wi)], maxBound);
  }

  bounds[hook(2, 0)] = minBound;
  bounds[hook(2, 1)] = maxBound;
}