//{"blockSums":2,"blockSumsSize":3,"dataSet":0,"localBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel__ExclusivePrefixScan(global float* dataSet, local float* localBuffer, global float* blockSums, const unsigned int blockSumsSize) {
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

  unsigned int ai = tid;
  unsigned int bi = tid + lwz;
  unsigned int gai = tid + bid * lwz * 2;
  unsigned int gbi = gai + lwz;
  unsigned int bankOffsetA = ((ai) >> 4);
  unsigned int bankOffsetB = ((bi) >> 4);
  localBuffer[hook(1, ai + bankOffsetA)] = (gai < blockSumsSize) ? dataSet[hook(0, gai)] : 0;
  localBuffer[hook(1, bi + bankOffsetB)] = (gbi < blockSumsSize) ? dataSet[hook(0, gbi)] : 0;

  for (unsigned int d = lwz; d > 0; d >>= 1) {
    barrier(0x01);

    if (tid < d) {
      unsigned int i = 2 * offset * tid;
      unsigned int ai = i + offset - 1;
      unsigned int bi = ai + offset;
      ai += ((ai) >> 4);
      bi += ((bi) >> 4);

      localBuffer[hook(1, bi)] += localBuffer[hook(1, ai)];
    }
    offset <<= 1;
  }

  barrier(0x01);
  if (tid < 1) {
    unsigned int index = localBufferSize - 1;
    index += ((index) >> 4);
    blockSums[hook(2, bid)] = localBuffer[hook(1, index)];
    localBuffer[hook(1, index)] = 0;
  }

  for (unsigned int d = 1; d < localBufferSize; d <<= 1) {
    offset >>= 1;
    barrier(0x01);

    if (tid < d) {
      unsigned int i = 2 * offset * tid;
      unsigned int ai = i + offset - 1;
      unsigned int bi = ai + offset;
      ai += ((ai) >> 4);
      bi += ((bi) >> 4);

      float tmp = localBuffer[hook(1, ai)];
      localBuffer[hook(1, ai)] = localBuffer[hook(1, bi)];
      localBuffer[hook(1, bi)] += tmp;
    }
  }

  barrier(0x01);
  if (gai < blockSumsSize)
    dataSet[hook(0, gai)] = localBuffer[hook(1, ai + bankOffsetA)];
  if (gbi < blockSumsSize)
    dataSet[hook(0, gbi)] = localBuffer[hook(1, bi + bankOffsetB)];
}