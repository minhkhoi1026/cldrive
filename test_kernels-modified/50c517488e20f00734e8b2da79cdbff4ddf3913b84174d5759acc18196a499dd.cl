//{"depth":7,"entries":8,"nodeCenterOfGravity":6,"nodeDepth":4,"nodeEntries":3,"nodeMass":5,"nodeState":2,"pointMass":1,"pointPosition":0}
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
kernel void treeSumNodes(global float4* pointPosition, global float* pointMass, global unsigned int* nodeState, global int* nodeEntries, global int* nodeDepth, global float* nodeMass, global float4* nodeCenterOfGravity, const int depth) {
  const unsigned int nodeIdx = get_global_id(0);

  if (nodeDepth[hook(4, nodeIdx)] == depth) {
    if (nodeState[hook(2, nodeIdx)] == 2) {
      float4 centerOfGravitySum = (float)0;
      float mass = (float)0;
      for (unsigned int childIdx = 0; childIdx < 4; childIdx++) {
        int childNodeIdx = nodeEntries[hook(3, nodeIdx * 4 + childIdx)];
        if (childNodeIdx < 0)
          continue;
        centerOfGravitySum += nodeCenterOfGravity[hook(6, childNodeIdx)];
        mass += nodeMass[hook(5, childNodeIdx)];
      }
      nodeCenterOfGravity[hook(6, nodeIdx)] = centerOfGravitySum / mass;
      nodeMass[hook(5, nodeIdx)] = mass;
    } else if (nodeState[hook(2, nodeIdx)] == 3) {
      float4 centerOfGravitySum = (float)0;
      float mass = (float)0;
      for (unsigned int childIdx = 0; childIdx < 4; childIdx++) {
        int pointIdx = nodeEntries[hook(3, nodeIdx * 4 + childIdx)];
        if (pointIdx < 0)
          break;
        centerOfGravitySum += pointPosition[hook(0, pointIdx)] * pointMass[hook(1, pointIdx)];
        mass += pointMass[hook(1, pointIdx)];
      }
      nodeCenterOfGravity[hook(6, nodeIdx)] = centerOfGravitySum / mass;
      nodeMass[hook(5, nodeIdx)] = mass;
    }
  }
}