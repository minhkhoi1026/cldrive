//{"blockBoundingBox":8,"blockCenter":7,"invPeriodicBoxSize":2,"numAtoms":0,"periodicBoxSize":1,"periodicBoxVecX":3,"periodicBoxVecY":4,"periodicBoxVecZ":5,"posq":6,"rebuildNeighborList":9,"sortedBlocks":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void findBlockBounds(int numAtoms, float4 periodicBoxSize, float4 invPeriodicBoxSize, float4 periodicBoxVecX, float4 periodicBoxVecY, float4 periodicBoxVecZ, global const float4* restrict posq, global float4* restrict blockCenter, global float4* restrict blockBoundingBox, global int* restrict rebuildNeighborList, global float2* restrict sortedBlocks) {
  int index = get_global_id(0);
  int base = index * 16;
  while (base < numAtoms) {
    float4 pos = posq[hook(6, base)];

    float4 minPos = pos;
    float4 maxPos = pos;
    int last = min(base + 16, numAtoms);
    for (int i = base + 1; i < last; i++) {
      pos = posq[hook(6, i)];

      minPos = min(minPos, pos);
      maxPos = max(maxPos, pos);
    }
    float4 blockSize = 0.5f * (maxPos - minPos);
    float4 center = 0.5f * (maxPos + minPos);
    center.w = 0;
    for (int i = base; i < last; i++) {
      pos = posq[hook(6, i)];
      float4 delta = posq[hook(6, i)] - center;

      center.w = max(center.w, delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
    }
    center.w = sqrt(center.w);
    blockBoundingBox[hook(8, index)] = blockSize;
    blockCenter[hook(7, index)] = center;
    sortedBlocks[hook(10, index)] = (float2)(blockSize.x + blockSize.y + blockSize.z, index);
    index += get_global_size(0);
    base = index * 16;
  }
  if (get_global_id(0) == 0)
    rebuildNeighborList[hook(9, 0)] = 0;
}