//{"depth":10,"entries":11,"globals":0,"nodeCenter":1,"nodeChildCount":4,"nodeDepth":7,"nodeEntries":5,"nodeHalf":2,"nodeParent":6,"nodeState":3,"pointIndex":9,"pointParent":8}
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
    if (atomic_cmpxchg(&entries[hook(11, childIdx)], -1, pointIdx) == -1) {
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
kernel void treeCreateNodes(global struct tree_global* globals, global float4* nodeCenter, global float4* nodeHalf, global unsigned int* nodeState, global unsigned int* nodeChildCount, global int* nodeEntries, global int* nodeParent, global int* nodeDepth, global unsigned int* pointParent, global unsigned int* pointIndex, const int depth) {
  const unsigned int nodeIdx = get_global_id(0);
  if (nodeState[hook(3, nodeIdx)] == 1) {
    int activeNodesDelta = -1;
    for (int childIdx = 0; childIdx < 4; childIdx++) {
      unsigned int count = nodeChildCount[hook(4, nodeIdx * 4 + childIdx)];
      if (count == 0)
        continue;

      unsigned int newNodeIdx = atomic_inc(&globals->nextNode);
      nodeEntries[hook(5, nodeIdx * 4 + childIdx)] = newNodeIdx;
      nodeHalf[hook(2, newNodeIdx)] = nodeHalf[hook(2, nodeIdx)] / 2.0f;
      nodeCenter[hook(1, newNodeIdx)] = nodeCenter[hook(1, nodeIdx)] + nodeHalf[hook(2, newNodeIdx)] * childDirection(childIdx);
      nodeParent[hook(6, newNodeIdx)] = nodeIdx;
      nodeDepth[hook(7, newNodeIdx)] = depth;
      globals->depth = depth;
      if (count <= 4) {
        nodeState[hook(3, newNodeIdx)] = 3;
      } else {
        nodeState[hook(3, newNodeIdx)] = 1;
        activeNodesDelta++;
      }
    }

    nodeState[hook(3, nodeIdx)] = 2;
    atomic_add(&globals->activeNodes, activeNodesDelta);
  }
}