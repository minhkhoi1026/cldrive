//{"digit_counts":5,"in":0,"isums":1,"lmem":3,"n":2,"shift":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global const unsigned int* in, global unsigned int* isums, const int n, local unsigned int* lmem, const int shift) {
  int region_size = ((n / 4) / get_num_groups(0)) * 4;
  int block_start = get_group_id(0) * region_size;

  int block_stop = (get_group_id(0) == get_num_groups(0) - 1) ? n : block_start + region_size;

  int tid = get_local_id(0);
  int i = block_start + tid;

  int digit_counts[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

  while (i < block_stop) {
    digit_counts[hook(5, (in[hook(0, i)] >> shift) & 15U)]++;
    i += get_local_size(0);
  }

  for (int d = 0; d < 16; d++) {
    lmem[hook(3, tid)] = digit_counts[hook(5, d)];
    barrier(0x01);

    for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
      if (tid < s) {
        lmem[hook(3, tid)] += lmem[hook(3, tid + s)];
      }
      barrier(0x01);
    }

    if (tid == 0) {
      isums[hook(1, (d * get_num_groups(0)) + get_group_id(0))] = lmem[hook(3, 0)];
    }
  }
}