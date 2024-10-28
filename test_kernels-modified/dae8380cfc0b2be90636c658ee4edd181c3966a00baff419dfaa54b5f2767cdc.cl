//{"arr":4,"dgBlockCounts":0,"dgValid":1,"dsCount":2,"len":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int sumReduce128(local unsigned int* arr);
unsigned int compactSIMDPrefixSum(local const unsigned int* dsData, local const unsigned int* dsValid, local unsigned int* dsCompact, local unsigned int* dsLocalIndex);
unsigned int exclusivePrescan128(local const unsigned int* in, local unsigned int* outAndTemp);
unsigned int sumReduce128(local unsigned int* arr) {
  const unsigned int idx = get_local_id(0);
  if (idx < 64)
    arr[hook(4, idx)] += arr[hook(4, idx + 64)];
  barrier(0x01);
  if (idx < 32)
    arr[hook(4, idx)] += arr[hook(4, idx + 32)];
  barrier(0x01);
  if (idx < 16)
    arr[hook(4, idx)] += arr[hook(4, idx + 16)];
  barrier(0x01);
  if (idx < 8)
    arr[hook(4, idx)] += arr[hook(4, idx + 8)];
  barrier(0x01);
  if (idx < 4)
    arr[hook(4, idx)] += arr[hook(4, idx + 4)];
  barrier(0x01);
  if (idx < 2)
    arr[hook(4, idx)] += arr[hook(4, idx + 2)];
  barrier(0x01);
  if (idx < 1)
    arr[hook(4, idx)] += arr[hook(4, idx + 1)];
  barrier(0x01);
  return arr[hook(4, 0)];
}

kernel void countElts(global unsigned int* restrict dgBlockCounts, global unsigned int* restrict dgValid, local unsigned int* restrict dsCount, private const unsigned int len) {
  const unsigned int idx = get_local_id(0);
  const unsigned int gidx = get_group_id(0);
  const unsigned int ngrps = get_num_groups(0);
  const unsigned int lsize = get_local_size(0);
  const unsigned int epb = len / ngrps + ((len % ngrps) ? 1 : 0);
  const unsigned int ub = (len < (gidx + 1) * epb) ? len : ((gidx + 1) * epb);
  dsCount[hook(2, idx)] = 0;
  for (unsigned int base = gidx * epb; base < (gidx + 1) * epb; base += lsize) {
    if ((base + idx) < ub && dgValid[hook(1, base + idx)])
      dsCount[hook(2, idx)]++;
  }
  barrier(0x01);
  unsigned int blockCount = sumReduce128(dsCount);
  if (idx == 0)
    dgBlockCounts[hook(0, gidx)] = blockCount;
  return;
}