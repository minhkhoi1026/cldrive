//{"blockScan":0,"prefixSum":3,"scanSum":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clBlockScan(global uint4* blockScan, global unsigned int* scanSum, unsigned int size) {
  int globalId = get_global_id(0);
  int threadid = get_local_id(0);
  int blockid = get_group_id(0);

  uint4 value4 = 0;
  if (globalId < size) {
    value4 = blockScan[hook(0, globalId)];
  }

  local unsigned int prefixSum[256];

  uint4 sum;
  sum.x = value4.x;
  sum.y = sum.x + value4.y;
  sum.z = sum.y + value4.z;
  sum.w = sum.z + value4.w;
  prefixSum[hook(3, threadid)] = sum.w;
  barrier(0x01);

  if (threadid == 256 - 1) {
    for (int i = 1; i < 256; i++) {
      prefixSum[hook(3, i)] += prefixSum[hook(3, i - 1)];
    }
  }
  barrier(0x01);

  unsigned int count = prefixSum[hook(3, threadid)] - sum.w;
  if (globalId < size) {
    uint4 result;
    result.x = count;
    result.y = count + sum.x;
    result.z = count + sum.y;
    result.w = count + sum.z;
    blockScan[hook(0, globalId)] = result;
  }
  barrier(0x01);

  if (threadid == 256 - 1) {
    scanSum[hook(1, blockid)] = count + sum.w;
  }
}