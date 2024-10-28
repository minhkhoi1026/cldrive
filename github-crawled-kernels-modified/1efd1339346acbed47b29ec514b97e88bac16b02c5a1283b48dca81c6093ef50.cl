//{"blockScan":0,"blockSum":1,"prefixSum":3,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clBlockPrefix(global uint4* blockScan, global unsigned int* blockSum, unsigned int size) {
  int globalId = get_global_id(0);
  int threadid = get_local_id(0);
  int blockid = get_group_id(0);

  local unsigned int prefixSum[256];

  prefixSum[hook(3, threadid)] = blockSum[hook(1, threadid)];
  barrier(0x01);

  if (threadid == 256 - 1) {
    for (int i = 1; i < 256; i++) {
      prefixSum[hook(3, i)] += prefixSum[hook(3, i - 1)];
    }
  }
  barrier(0x01);

  if (blockid > 0 && globalId < size) {
    blockScan[hook(0, globalId)] = blockScan[hook(0, globalId)] + prefixSum[hook(3, blockid - 1)];
  }
}