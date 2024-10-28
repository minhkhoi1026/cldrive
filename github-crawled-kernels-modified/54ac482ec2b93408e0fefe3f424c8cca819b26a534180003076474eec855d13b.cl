//{"block_size":3,"histogram":1,"output":0,"sharedMem":2,"sumBuffer":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void blockScan(global unsigned int* output, global unsigned int* histogram, local unsigned int* sharedMem, const unsigned int block_size, global unsigned int* sumBuffer) {
  int idx = get_local_id(0);
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int bidx = get_group_id(0);
  int bidy = get_group_id(1);

  int gpos = (gidx << 8) + gidy;
  int groupIndex = bidy * (get_global_size(0) / block_size) + bidx;

  sharedMem[hook(2, idx)] = histogram[hook(1, gpos)];
  barrier(0x01);

  unsigned int cache = sharedMem[hook(2, 0)];
  for (int stride = 1; stride < block_size; stride <<= 1) {
    if (idx >= stride) {
      cache = sharedMem[hook(2, idx - stride)] + sharedMem[hook(2, idx)];
    }
    barrier(0x01);

    sharedMem[hook(2, idx)] = cache;
    barrier(0x01);
  }

  if (idx == 0) {
    sumBuffer[hook(4, groupIndex)] = sharedMem[hook(2, block_size - 1)];
    output[hook(0, gpos)] = 0;
  } else {
    output[hook(0, gpos)] = sharedMem[hook(2, idx - 1)];
  }
}