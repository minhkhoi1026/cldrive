//{"entries":8,"globals":0,"maxBoundGroup":6,"minBoundGroup":5,"nodeCenter":1,"nodeDepth":4,"nodeHalf":2,"nodeState":3,"numWorkItems":7}
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
    if (atomic_cmpxchg(&entries[hook(8, childIdx)], -1, pointIdx) == -1) {
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
kernel void treeGetRootBoundsSum(global struct tree_global* globals, global float4* nodeCenter, global float4* nodeHalf, global unsigned int* nodeState, global int* nodeDepth, global float4* minBoundGroup, global float4* maxBoundGroup, const unsigned int numWorkItems) {
  float4 minBound = (float4)0x1.fffffep127f;
  float4 maxBound = (float4)-0x1.fffffep127f;
  for (unsigned int wi = 0; wi < numWorkItems; wi++) {
    minBound = min(minBoundGroup[hook(5, wi)], minBound);
    maxBound = max(maxBoundGroup[hook(6, wi)], maxBound);
  }

  float max = fmax(fmax(fabs(minBound.x), fabs(maxBound.x)), fmax(fabs(minBound.y), fabs(maxBound.y)));

  nodeCenter[hook(1, 0)] = 0.0f;
  nodeHalf[hook(2, 0)] = roundPow2(max);
  nodeState[hook(3, 0)] = 1;
  nodeDepth[hook(4, 0)] = 0;

  globals->nextNode = 1;
  globals->activeNodes = 1;
}