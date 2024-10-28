//{"block":2,"block_size":3,"input":1,"length":4,"output":0,"sumBuffer":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ScanLargeArrays(global float* output, global float* input, local float* block, const unsigned int block_size, const unsigned int length, global float* sumBuffer) {
  int tid = get_local_id(0);
  int gid = get_global_id(0);
  int bid = get_group_id(0);

  int offset = 1;

  block[hook(2, 2 * tid)] = input[hook(1, 2 * gid)];
  block[hook(2, 2 * tid + 1)] = input[hook(1, 2 * gid + 1)];

  for (int d = block_size >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      block[hook(2, bi)] += block[hook(2, ai)];
    }
    offset *= 2;
  }

  barrier(0x01);

  int group_id = get_group_id(0);

  sumBuffer[hook(5, bid)] = block[hook(2, block_size - 1)];

  barrier(0x01 | 0x02);

  block[hook(2, block_size - 1)] = 0;

  for (int d = 1; d < block_size; d *= 2) {
    offset >>= 1;
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      float t = block[hook(2, ai)];
      block[hook(2, ai)] = block[hook(2, bi)];
      block[hook(2, bi)] += t;
    }
  }

  barrier(0x01);

  if (group_id == 0) {
    output[hook(0, 2 * gid)] = block[hook(2, 2 * tid)];
    output[hook(0, 2 * gid + 1)] = block[hook(2, 2 * tid + 1)];
  } else {
    output[hook(0, 2 * gid)] = block[hook(2, 2 * tid)];
    output[hook(0, 2 * gid + 1)] = block[hook(2, 2 * tid + 1)];
  }
}