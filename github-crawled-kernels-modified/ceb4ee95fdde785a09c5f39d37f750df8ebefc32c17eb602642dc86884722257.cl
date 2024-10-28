//{"blockOffset":6,"blockScan":5,"key":8,"keyIn":0,"keyOut":1,"offset":10,"prefixSum":9,"size":7,"startbit":4,"valIn":2,"valOut":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clBlockSort(global unsigned int* keyIn, global unsigned int* keyOut, global unsigned int* valIn, global unsigned int* valOut, unsigned int startbit, global unsigned int* blockScan, global unsigned int* blockOffset, unsigned int size, local unsigned int* key, local unsigned int* prefixSum) {
  int globalId = get_global_id(0);
  int threadid = get_local_id(0);
  int totalBlocks = get_num_groups(0);
  int blockid = get_group_id(0);

  size_t blockSize = get_local_size(0);

  key[hook(8, threadid)] = 0xFFFFFFFF;

  if (globalId < size) {
    key[hook(8, threadid)] = keyIn[hook(0, globalId)];
  }
  barrier(0x01);

  for (unsigned int bit = startbit; bit < (startbit + 4); bit++) {
    unsigned int curKey = key[hook(8, threadid)];

    unsigned int lsb = !((curKey >> bit) & 0x1);
    prefixSum[hook(9, threadid)] = lsb;
    barrier(0x01);
    if (threadid == blockSize - 1) {
      for (int i = 1; i < blockSize; i++) {
        prefixSum[hook(9, i)] += prefixSum[hook(9, i - 1)];
      }
    }
    barrier(0x01);
    unsigned int address = lsb ? prefixSum[hook(9, threadid)] - 1 : prefixSum[hook(9, blockSize - 1)] - prefixSum[hook(9, threadid)] + threadid;
    key[hook(8, address)] = curKey;

    barrier(0x01);
  }

  if (globalId < size) {
    keyOut[hook(1, globalId)] = key[hook(8, threadid)];
  }
  barrier(0x01);

  local unsigned int offset[(1 << 4)];
  if (threadid < (1 << 4)) {
    offset[hook(10, threadid)] = 0;
  }
  key[hook(8, threadid)] = (key[hook(8, threadid)] >> startbit) & 0xF;
  barrier(0x01);

  if (threadid > 0 && key[hook(8, threadid)] != key[hook(8, threadid - 1)]) {
    offset[hook(10, key[thook(8, threadid))] = threadid;
  }
  barrier(0x01);

  if (threadid < (1 << 4)) {
    blockOffset[hook(6, blockid * (1 << 4) + threadid)] = offset[hook(10, threadid)];
  }
  barrier(0x01);

  if (threadid > 0 && key[hook(8, threadid)] != key[hook(8, threadid - 1)]) {
    offset[hook(10, key[thook(8, threadid - 1))] = threadid - offset[hook(10, key[thook(8, threadid - 1))];
  }
  barrier(0x01);

  if (threadid == blockSize - 1) {
    offset[hook(10, key[bhook(8, blockSize - 1))] = blockSize - offset[hook(10, key[bhook(8, blockSize - 1))];
  }
  barrier(0x01);

  if (threadid < (1 << 4)) {
    blockScan[hook(5, threadid * totalBlocks + blockid)] = offset[hook(10, threadid)];
  }
}