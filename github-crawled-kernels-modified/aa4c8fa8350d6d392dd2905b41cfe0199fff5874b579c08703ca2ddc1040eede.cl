//{"blockSums":2,"blockSumsSize":3,"dataSet":0,"localBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel__ExclusivePrefixScan(global int* dataSet, local int* localBuffer, global int* blockSums, const unsigned int blockSumsSize) {
  const unsigned int gid = get_global_id(0);
  const unsigned int tid = get_local_id(0);
  const unsigned int bid = get_group_id(0);
  const unsigned int lwz = get_local_size(0);

  const unsigned int localBufferSize = lwz << 1;
  int offset = 1;

  const int tid2_0 = tid << 1;
  const int tid2_1 = tid2_0 + 1;

  const int gid2_0 = gid << 1;
  const int gid2_1 = gid2_0 + 1;
  localBuffer[hook(1, tid2_0)] = (gid2_0 < blockSumsSize) ? dataSet[hook(0, gid2_0)] : 0;
  localBuffer[hook(1, tid2_1)] = (gid2_1 < blockSumsSize) ? dataSet[hook(0, gid2_1)] : 0;

  for (unsigned int d = lwz; d > 0; d >>= 1) {
    barrier(0x01);

    if (tid < d) {
      const unsigned int ai = mad24(offset, (tid2_1 + 0), -1);
      const unsigned int bi = mad24(offset, (tid2_1 + 1), -1);

      localBuffer[hook(1, bi)] += localBuffer[hook(1, ai)];
    }
    offset <<= 1;
  }

  barrier(0x01);
  if (tid < 1) {
    blockSums[hook(2, bid)] = localBuffer[hook(1, localBufferSize - 1)];

    localBuffer[hook(1, localBufferSize - 1)] = 0;
  }

  for (unsigned int d = 1; d < localBufferSize; d <<= 1) {
    offset >>= 1;
    barrier(0x01);

    if (tid < d) {
      const unsigned int ai = mad24(offset, (tid2_1 + 0), -1);
      const unsigned int bi = mad24(offset, (tid2_1 + 1), -1);

      int tmp = localBuffer[hook(1, ai)];
      localBuffer[hook(1, ai)] = localBuffer[hook(1, bi)];
      localBuffer[hook(1, bi)] += tmp;
    }
  }

  barrier(0x01);

  if (gid2_0 < blockSumsSize)
    dataSet[hook(0, gid2_0)] = localBuffer[hook(1, tid2_0)];
  if (gid2_1 < blockSumsSize)
    dataSet[hook(0, gid2_1)] = localBuffer[hook(1, tid2_1)];
}