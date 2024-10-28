//{"block":4,"block_size":2,"input":0,"output":1,"sumBuffer":3,"value":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute((num_compute_units(16))) void ScanLargeArrays_kernel(global int* restrict output, global int* restrict input, const unsigned int block_size, global int* restrict sumBuffer) {
  int tid = get_local_id(0);
  int gid = get_global_id(0);
  int bid = get_group_id(0);

  local int block[512];

  block[hook(4, 2 * tid)] = input[hook(0, 2 * gid)];
  block[hook(4, 2 * tid + 1)] = input[hook(0, 2 * gid + 1)];

  int offset = 1;

  for (int d = block_size >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      block[hook(4, bi)] += block[hook(4, ai)];
    }
    offset *= 2;
  }
  barrier(0x01);

  sumBuffer[hook(3, bid)] = block[hook(4, block_size - 1)];

  barrier(0x01 | 0x02);

  block[hook(4, block_size - 1)] = 0;

  for (int d = 1; d < block_size; d *= 2) {
    offset >>= 1;
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      int t = block[hook(4, ai)];
      block[hook(4, ai)] = block[hook(4, bi)];
      block[hook(4, bi)] += t;
    }
  }
  barrier(0x01);

  {
    output[hook(1, 2 * gid)] = block[hook(4, 2 * tid)];
    output[hook(1, 2 * gid + 1)] = block[hook(4, 2 * tid + 1)];
  }
}

kernel void blockAddition_kernel(global int* restrict input, global int* restrict output) {
  int globalId = get_global_id(0);
  int groupId = get_group_id(0);
  int localId = get_local_id(0);

  local int value[1];

  if (localId == 0) {
    value[hook(5, 0)] = input[hook(0, groupId)];
  }
  barrier(0x01);

  output[hook(1, globalId * 2)] += value[hook(5, 0)];
  output[hook(1, globalId * 2 + 1)] += value[hook(5, 0)];
}