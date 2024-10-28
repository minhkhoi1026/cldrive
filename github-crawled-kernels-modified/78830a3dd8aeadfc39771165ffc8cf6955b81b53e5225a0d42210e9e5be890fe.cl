//{"entries":5,"nodeChildCount":1,"nodeEntries":2,"nodeState":0,"pointIndex":4,"pointParent":3}
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
    if (atomic_cmpxchg(&entries[hook(5, childIdx)], -1, pointIdx) == -1) {
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
kernel void treeInsertPoints(global unsigned int* nodeState, global unsigned int* nodeChildCount, global int* nodeEntries, global unsigned int* pointParent, global unsigned int* pointIndex) {
  const unsigned int pointIdx = get_global_id(0);

  if (nodeState[hook(0, pointParent[phook(3, pointIdx))] == 2) {
    unsigned int parentNodeIdx = pointParent[hook(3, pointIdx)];
    unsigned int childIdx = pointIndex[hook(4, pointIdx)];
    unsigned int count = nodeChildCount[hook(1, parentNodeIdx * 4 + childIdx)];
    unsigned int childNodeIdx = nodeEntries[hook(2, parentNodeIdx * 4 + childIdx)];

    pointParent[hook(3, pointIdx)] = childNodeIdx;

    if (count <= 4) {
      insertPoint(nodeEntries + childNodeIdx * 4, pointIdx);
    }
  }
}