//{"block_size":3,"input":1,"output":0,"sharedMem":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unifiedBlockScan(global unsigned int* output, global unsigned int* input, local unsigned int* sharedMem, const unsigned int block_size) {
  int id = get_local_id(0);
  int gid = get_global_id(0);
  int bid = get_group_id(0);

  sharedMem[hook(2, id)] = input[hook(1, gid)];

  unsigned int cache = sharedMem[hook(2, 0)];

  for (int stride = 1; stride < block_size; stride <<= 1) {
    if (id >= stride) {
      cache = sharedMem[hook(2, id - stride)] + sharedMem[hook(2, id)];
    }
    barrier(0x01);

    sharedMem[hook(2, id)] = cache;
    barrier(0x01);
  }

  if (id == 0) {
    output[hook(0, gid)] = 0;
  } else {
    output[hook(0, gid)] = sharedMem[hook(2, id - 1)];
  }
}