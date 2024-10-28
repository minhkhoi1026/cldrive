//{"blockPrefixSum":3,"blockSums":2,"elements":0,"numElements":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void localScan(global unsigned int* elements, unsigned int numElements, global unsigned int* blockSums) {
  const unsigned int lid0 = get_local_id(0);
  const unsigned int gid0 = get_global_id(0);

  local unsigned int blockPrefixSum[128];

  if (gid0 < numElements)
    blockPrefixSum[hook(3, lid0)] = elements[hook(0, gid0)];
  else
    blockPrefixSum[hook(3, lid0)] = 0;
  barrier(0x01);

  for (unsigned int i = 2; i <= 128; i <<= 1) {
    unsigned int idx = (lid0 + 1) * i - 1;
    if (idx < 128)
      blockPrefixSum[hook(3, idx)] += blockPrefixSum[hook(3, idx - (i >> 1))];
    barrier(0x01);
  }

  if (lid0 == 0) {
    blockSums[hook(2, (get_global_offset(0) / 128) + get_group_id(0))] = blockPrefixSum[hook(3, 128 - 1)];
    blockPrefixSum[hook(3, 128 - 1)] = 0;
  }
  barrier(0x01);
  for (unsigned int i = 128; i >= 2; i >>= 1) {
    unsigned int idx1 = (lid0 + 1) * i - 1;
    if (idx1 < 128) {
      unsigned int idx0 = idx1 - (i >> 1);
      unsigned int temp = blockPrefixSum[hook(3, idx0)];
      blockPrefixSum[hook(3, idx0)] = blockPrefixSum[hook(3, idx1)];
      blockPrefixSum[hook(3, idx1)] += temp;
    }
    barrier(0x01);
  }

  if (gid0 < numElements)
    elements[hook(0, gid0)] = blockPrefixSum[hook(3, lid0)];
}