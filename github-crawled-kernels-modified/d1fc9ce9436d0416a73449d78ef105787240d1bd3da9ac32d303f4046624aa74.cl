//{"arr":4,"dgBlockCounts":0,"dgValid":1,"dsCount":3,"len":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int sumReduce128(local unsigned int* arr) {
  int thread = get_local_id(0);
  if (thread < 64)
    arr[hook(4, thread)] += arr[hook(4, thread + 64)];
  barrier(0x01);
  if (thread < 32)
    arr[hook(4, thread)] += arr[hook(4, thread + 32)];
  barrier(0x01);
  if (thread < 16)
    arr[hook(4, thread)] += arr[hook(4, thread + 16)];
  barrier(0x01);
  if (thread < 8)
    arr[hook(4, thread)] += arr[hook(4, thread + 8)];
  barrier(0x01);
  if (thread < 4)
    arr[hook(4, thread)] += arr[hook(4, thread + 4)];
  barrier(0x01);
  if (thread < 2)
    arr[hook(4, thread)] += arr[hook(4, thread + 2)];
  barrier(0x01);
  if (thread < 1)
    arr[hook(4, thread)] += arr[hook(4, thread + 1)];

  barrier(0x01);
  return arr[hook(4, 0)];
}

kernel void countElts(global unsigned int* restrict dgBlockCounts, global const unsigned int* restrict dgValid, const unsigned int len, local unsigned int* restrict dsCount) {
  dsCount[hook(3, get_local_id(0))] = 0;
  unsigned int ub;
  const unsigned int eltsPerBlock = len / get_num_groups(0) + ((len % get_num_groups(0)) ? 1 : 0);
  ub = (len < (get_group_id(0) + 1) * eltsPerBlock) ? len : ((get_group_id(0) + 1) * eltsPerBlock);
  for (int base = get_group_id(0) * eltsPerBlock; base < (get_group_id(0) + 1) * eltsPerBlock; base += get_local_size(0)) {
    if ((base + get_local_id(0)) < ub && dgValid[hook(1, base + get_local_id(0))])
      dsCount[hook(3, get_local_id(0))]++;
  }
  barrier(0x01);
  unsigned int blockCount = sumReduce128(dsCount);
  if (get_local_id(0) == 0)
    dgBlockCounts[hook(0, get_group_id(0))] = blockCount;
  return;
}