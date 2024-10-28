//{"in":0,"isums":1,"lmem":3,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global const float* in, global float* isums, const int n, local float* lmem) {
  int region_size = ((n / 4) / get_num_groups(0)) * 4;
  int block_start = get_group_id(0) * region_size;

  int block_stop = (get_group_id(0) == get_num_groups(0) - 1) ? n : block_start + region_size;

  int tid = get_local_id(0);
  int i = block_start + tid;

  float sum = 0.0f;

  while (i < block_stop) {
    sum += in[hook(0, i)];
    i += get_local_size(0);
  }

  lmem[hook(3, tid)] = sum;
  barrier(0x01);

  for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      lmem[hook(3, tid)] += lmem[hook(3, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0) {
    isums[hook(1, get_group_id(0))] = lmem[hook(3, 0)];
  }
}