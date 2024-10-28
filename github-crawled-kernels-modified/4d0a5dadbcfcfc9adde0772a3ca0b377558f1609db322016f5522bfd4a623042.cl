//{"entries":18,"globals":0,"maxBoundGroup":4,"maxNodes":17,"minBoundGroup":3,"nodeCenter":5,"nodeCenterOfGravity":8,"nodeChildCount":12,"nodeDepth":11,"nodeEntries":13,"nodeHalf":6,"nodeMass":7,"nodeParent":10,"nodeState":9,"numPoints":16,"pointIndex":15,"pointMass":2,"pointParent":14,"pointPosition":1}
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
    if (atomic_cmpxchg(&entries[hook(18, childIdx)], -1, pointIdx) == -1) {
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
kernel void treeBuild(global struct tree_global* globals, global float4* pointPosition, global float* pointMass, local float4* minBoundGroup, local float4* maxBoundGroup, global float4* nodeCenter, global float4* nodeHalf, global float* nodeMass, global float4* nodeCenterOfGravity, global unsigned int* nodeState, global int* nodeParent, global int* nodeDepth, global unsigned int* nodeChildCount, global int* nodeEntries, global unsigned int* pointParent, global unsigned int* pointIndex, const unsigned int numPoints, const unsigned int maxNodes) {
  unsigned int i;

  i = get_global_id(0);
  while (i < numPoints) {
    pointParent[hook(14, i)] = 0;
    i += get_global_size(0);
  }

  i = get_global_id(0);
  while (i < maxNodes) {
    nodeState[hook(9, i)] = 0;
    nodeParent[hook(10, i)] = -1;
    for (int childIdx = 0; childIdx < 4; childIdx++) {
      nodeEntries[hook(13, i * 4 + childIdx)] = -1;
    }
    for (int childIdx = 0; childIdx < 4; childIdx++) {
      nodeChildCount[hook(12, i * 4 + childIdx)] = 0;
    }
    i += get_global_size(0);
  }

  float4 minBound = (float4)0x1.fffffep127f;
  float4 maxBound = (float4)-0x1.fffffep127f;
  i = get_global_id(0);
  while (i < numPoints) {
    float4 position = pointPosition[hook(1, i)];
    minBound = min(position, minBound);
    maxBound = max(position, maxBound);
    i += get_global_size(0);
  }
  minBoundGroup[hook(3, get_global_id(0))] = minBound;
  maxBoundGroup[hook(4, get_global_id(0))] = maxBound;

  barrier(0x01);

  if (get_global_id(0) == 0) {
    minBound = (float4)0x1.fffffep127f;
    maxBound = (float4)-0x1.fffffep127f;
    for (i = 0; i < get_global_size(0); i++) {
      minBound = min(minBoundGroup[hook(3, i)], minBound);
      maxBound = max(maxBoundGroup[hook(4, i)], maxBound);
    }
    float max = fmax(fmax(fabs(minBound.x), fabs(maxBound.x)), fmax(fabs(minBound.y), fabs(maxBound.y)));
    nodeCenter[hook(5, 0)] = 0.0f;
    nodeHalf[hook(6, 0)] = roundPow2(max);
    nodeState[hook(9, 0)] = 1;
    nodeDepth[hook(11, 0)] = 0;
    globals->nextNode = 1;
    globals->activeNodes = 1;
  }

  barrier(0x02);

  int depth = 0;

  do {
    depth++;

    i = get_global_id(0);
    while (i < numPoints) {
      const unsigned int parentIdx = pointParent[hook(14, i)];

      if (nodeState[hook(9, parentIdx)] == 1) {
        float4 delta = pointPosition[hook(1, i)] - nodeCenter[hook(5, parentIdx)];
        const unsigned int childIdx = childIndex(delta);
        pointIndex[hook(15, i)] = childIdx;
        atomic_inc(&nodeChildCount[hook(12, parentIdx * 4 + childIdx)]);
      }
      i += get_global_size(0);
    }

    barrier(0x02 | 0x01);

    unsigned int nextNode = globals->nextNode;

    i = get_global_id(0);
    while (i < nextNode) {
      if (nodeState[hook(9, i)] == 1) {
        int activeNodesDelta = -1;
        for (int childIdx = 0; childIdx < 4; childIdx++) {
          unsigned int count = nodeChildCount[hook(12, i * 4 + childIdx)];
          if (count == 0)
            continue;

          unsigned int newNodeIdx = atomic_inc(&globals->nextNode);
          nodeEntries[hook(13, i * 4 + childIdx)] = newNodeIdx;
          nodeHalf[hook(6, newNodeIdx)] = nodeHalf[hook(6, i)] / 2.0f;
          nodeCenter[hook(5, newNodeIdx)] = nodeCenter[hook(5, i)] + nodeHalf[hook(6, newNodeIdx)] * childDirection(childIdx);
          nodeParent[hook(10, newNodeIdx)] = i;
          nodeDepth[hook(11, newNodeIdx)] = depth;
          globals->depth = depth;
          if (count <= 4) {
            nodeState[hook(9, newNodeIdx)] = 3;
          } else {
            nodeState[hook(9, newNodeIdx)] = 1;
            activeNodesDelta++;
          }
        }

        nodeState[hook(9, i)] = 2;
        atomic_add(&globals->activeNodes, activeNodesDelta);
      }
      i += get_global_size(0);
    }

    barrier(0x02);

    i = get_global_id(0);
    while (i < numPoints) {
      if (nodeState[hook(9, pointParent[ihook(14, i))] == 2) {
        unsigned int parentNodeIdx = pointParent[hook(14, i)];
        unsigned int childIdx = pointIndex[hook(15, i)];
        unsigned int count = nodeChildCount[hook(12, parentNodeIdx * 4 + childIdx)];
        unsigned int childNodeIdx = nodeEntries[hook(13, parentNodeIdx * 4 + childIdx)];

        pointParent[hook(14, i)] = childNodeIdx;

        if (count <= 4) {
          insertPoint(nodeEntries + childNodeIdx * 4, i);
        }
      }
      i += get_global_size(0);
    }

    barrier(0x02);

  } while (depth <= globals->depth);

  for (int rdepth = depth; rdepth >= 0; rdepth--) {
    i = get_global_id(0);
    while (i < maxNodes) {
      if (nodeDepth[hook(11, i)] == rdepth) {
        if (nodeState[hook(9, i)] == 2) {
          float4 centerOfGravitySum = (float)0;
          float mass = (float)0;
          for (unsigned int childIdx = 0; childIdx < 4; childIdx++) {
            int childNodeIdx = nodeEntries[hook(13, i * 4 + childIdx)];
            if (childNodeIdx < 0)
              continue;
            centerOfGravitySum += nodeCenterOfGravity[hook(8, childNodeIdx)];
            mass += nodeMass[hook(7, childNodeIdx)];
          }
          nodeCenterOfGravity[hook(8, i)] = centerOfGravitySum / mass;
          nodeMass[hook(7, i)] = mass;
        } else if (nodeState[hook(9, i)] == 3) {
          float4 centerOfGravitySum = (float)0;
          float mass = (float)0;
          for (unsigned int childIdx = 0; childIdx < 4; childIdx++) {
            int pointIdx = nodeEntries[hook(13, i * 4 + childIdx)];
            if (pointIdx < 0)
              break;
            centerOfGravitySum += pointPosition[hook(1, pointIdx)] * pointMass[hook(2, pointIdx)];
            mass += pointMass[hook(2, pointIdx)];
          }
          nodeCenterOfGravity[hook(8, i)] = centerOfGravitySum / mass;
          nodeMass[hook(7, i)] = mass;
        }
      }
      i += get_global_size(0);
    }

    barrier(0x02);
  }
}