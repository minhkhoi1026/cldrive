//{"entries":6,"globals":0,"maxBoundGroup":3,"minBoundGroup":2,"numPoints":5,"pointPosition":1,"workGroupSize":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct tree_global {
  volatile int nextNode;
  volatile int activeNodes;
  int depth;
  int pad;
};

void insertPoint(global int* entries, const unsigned int pointIdx);
int childIndex(float4 delta);
float4 childDirection(int idx);
float roundPow2(float val);

void insertPoint(global int* entries, const unsigned int pointIdx) {
  for (int childIdx = 0; childIdx < 4; childIdx++) {
    if (atomic_cmpxchg(&entries[hook(6, childIdx)], -1, pointIdx) == -1) {
      break;
    }
  }
}

int childIndex(float4 delta) {
  if (delta.x <= 0 && delta.y <= 0)
    return 0;
  else if (delta.x <= 0 && delta.y >= 0)
    return 1;
  else if (delta.x >= 0 && delta.y <= 0)
    return 2;
  else
    return 3;
}

float4 childDirection(int idx) {
  switch (idx) {
    case 0:
      return (float4)(-1.0f, -1.0f, 0.0f, 0.0f);
    case 1:
      return (float4)(-1.0f, 1.0f, 0.0f, 0.0f);
    case 2:
      return (float4)(1.0f, -1.0f, 0.0f, 0.0f);
    case 3:
    default:
      return (float4)(1.0f, 1.0f, 0.0f, 0.0f);
  }
}
float roundPow2(float val) {
  int exp;
  float m = frexp(val, &exp);

  int r = (int)(1.0f / m);

  r--;
  r |= r >> 1;
  r |= r >> 2;
  r |= r >> 4;
  r |= r >> 8;
  r |= r >> 16;
  r++;

  return (1.0f / r) * pow(2.0f, exp);
}
kernel void treeGetRootBoundsGroup(global struct tree_global* globals, global float4* pointPosition, global float4* minBoundGroup, global float4* maxBoundGroup, const unsigned int workGroupSize, const unsigned int numPoints) {
  const unsigned int wi = get_global_id(0);
  const unsigned int pstart = wi * workGroupSize;
  const unsigned int pend = min((wi + 1) * workGroupSize, numPoints);

  float4 minBound = (float4)0x1.fffffep127f;
  float4 maxBound = (float4)-0x1.fffffep127f;
  for (unsigned int pointIdx = pstart; pointIdx < pend; pointIdx++) {
    float4 position = pointPosition[hook(1, pointIdx)];
    minBound = min(position, minBound);
    maxBound = max(position, maxBound);
  }
  minBoundGroup[hook(2, wi)] = minBound;
  maxBoundGroup[hook(3, wi)] = maxBound;
}