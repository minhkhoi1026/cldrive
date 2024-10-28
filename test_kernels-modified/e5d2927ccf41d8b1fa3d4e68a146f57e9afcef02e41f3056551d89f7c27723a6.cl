//{"KMeansCluster":1,"centroidPos":2,"globalClusterBin":3,"globalClusterCount":4,"k":7,"localBinPtr":9,"localClusterBin":5,"localClusterCount":6,"numPoints":8,"pointPos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void atomicAddGlobal(volatile global float* ptr, float value) {
  unsigned int oldIntVal, newIntVal;
  float newFltVal;

  do {
    oldIntVal = *((volatile global unsigned int*)ptr);
    newFltVal = ((*(float*)(&oldIntVal)) + value);
    newIntVal = *((unsigned int*)(&newFltVal));
  } while (atomic_cmpxchg((volatile global unsigned int*)ptr, oldIntVal, newIntVal) != oldIntVal);
}

void atomicAddLocal(volatile local float* ptr, float value) {
  unsigned int oldIntVal, newIntVal;
  float newFltVal;

  do {
    oldIntVal = *((volatile local unsigned int*)ptr);
    newFltVal = ((*(float*)(&oldIntVal)) + value);
    newIntVal = *((unsigned int*)(&newFltVal));
  } while (atomic_cmpxchg((volatile local unsigned int*)ptr, oldIntVal, newIntVal) != oldIntVal);
}

kernel void assignCentroid(global float2* pointPos, global unsigned int* KMeansCluster, global float2* centroidPos, global float2* globalClusterBin, global unsigned int* globalClusterCount, local float2* localClusterBin, local unsigned int* localClusterCount, unsigned int k, unsigned int numPoints) {
  unsigned int gid = get_global_id(0);
  unsigned int lid = get_local_id(0);
  local float* localBinPtr = (local float*)localClusterBin;

  if (lid < k) {
    localClusterBin[hook(5, lid)] = (float2)0.0;
    localClusterCount[hook(6, lid)] = 0;
  }
  barrier(0x01);

  float2 vPoint = pointPos[hook(0, gid)];
  float leastDist = 0x1.fffffep127f;
  unsigned int closestCentroid = 0;

  for (int i = 0; i < k; i++) {
    float xDist = (vPoint.x - centroidPos[hook(2, i)].x);
    float yDist = (vPoint.y - centroidPos[hook(2, i)].y);
    float dist = (xDist * xDist) + (yDist * yDist);

    leastDist = fmin(leastDist, dist);

    closestCentroid = (leastDist == dist) ? i : closestCentroid;
  }

  KMeansCluster[hook(1, gid)] = closestCentroid;

  atomicAddLocal(&localBinPtr[hook(9, 2 * closestCentroid)], vPoint.x);
  atomicAddLocal(&localBinPtr[hook(9, 2 * closestCentroid + 1)], vPoint.y);
  atomic_inc(&localClusterCount[hook(6, closestCentroid)]);
  barrier(0x01);

  if (lid < k) {
    atomicAddGlobal(((global float*)(globalClusterBin) + (2 * lid)), localClusterBin[hook(5, lid)].x);
    atomicAddGlobal(((global float*)(globalClusterBin) + (2 * lid) + 1), localClusterBin[hook(5, lid)].y);
    atomic_add(&globalClusterCount[hook(4, lid)], localClusterCount[hook(6, lid)]);
  }
}