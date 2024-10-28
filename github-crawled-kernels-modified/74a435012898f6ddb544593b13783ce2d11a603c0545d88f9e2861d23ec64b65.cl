//{"blockOffset":9,"blockScan":4,"keyIn":0,"keyOut":1,"offsets":5,"size":7,"startbit":6,"totalOffset":8,"valIn":2,"valOut":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clReorder(global unsigned int* keyIn, global unsigned int* keyOut, global unsigned int* valIn, global unsigned int* valOut, global unsigned int* blockScan, global unsigned int* offsets, unsigned int startbit, unsigned int size) {
  int globalId = get_global_id(0);
  int threadid = get_local_id(0);
  int blockid = get_group_id(0);
  int totalBlocks = get_num_groups(0);

  local unsigned int blockOffset[(1 << 4)];
  local unsigned int totalOffset[(1 << 4)];

  if (threadid < (1 << 4)) {
    totalOffset[hook(8, threadid)] = blockScan[hook(4, threadid * totalBlocks + blockid)];
    blockOffset[hook(9, threadid)] = offsets[hook(5, blockid * (1 << 4) + threadid)];
  }
  barrier(0x01);

  if (globalId >= size) {
    return;
  }

  unsigned int key = keyIn[hook(0, globalId)];
  unsigned int val = valIn[hook(2, globalId)];
  unsigned int radix = (key >> startbit) & 0xF;
  unsigned int index = totalOffset[hook(8, radix)] + threadid - blockOffset[hook(9, radix)];
  keyOut[hook(1, index)] = key;
  valOut[hook(3, index)] = val;
}