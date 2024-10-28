//{"arr":9,"compactBlock":7,"dgBlockCounts":4,"dgCompact":2,"dgData":1,"dgValid":3,"dsCompact":13,"dsData":15,"dsLocalIndex":14,"dsValid":12,"in":11,"inBlock":5,"len":8,"outAndTemp":10,"result":0,"validBlock":6}
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
    arr[hook(9, idx)] += arr[hook(9, idx + 64)];
  barrier(0x01);
  if (idx < 32)
    arr[hook(9, idx)] += arr[hook(9, idx + 32)];
  barrier(0x01);
  if (idx < 16)
    arr[hook(9, idx)] += arr[hook(9, idx + 16)];
  barrier(0x01);
  if (idx < 8)
    arr[hook(9, idx)] += arr[hook(9, idx + 8)];
  barrier(0x01);
  if (idx < 4)
    arr[hook(9, idx)] += arr[hook(9, idx + 4)];
  barrier(0x01);
  if (idx < 2)
    arr[hook(9, idx)] += arr[hook(9, idx + 2)];
  barrier(0x01);
  if (idx < 1)
    arr[hook(9, idx)] += arr[hook(9, idx + 1)];
  barrier(0x01);
  return arr[hook(9, 0)];
}

unsigned int exclusivePrescan128(local const unsigned int* in, local unsigned int* outAndTemp) {
  const unsigned int idx = get_local_id(0);
  int pout = 1;
  int pin = 0;

  outAndTemp[hook(10, pout * 128 + idx)] = (idx > 0) ? in[hook(11, idx - 1)] : 0;
  barrier(0x01);
  for (unsigned int offset = 1; offset < 128; offset *= 2) {
    pout = 1 - pout;
    pin = 1 - pout;
    barrier(0x01);
    outAndTemp[hook(10, pout * 128 + idx)] = outAndTemp[hook(10, pin * 128 + idx)];
    if (idx >= offset)
      outAndTemp[hook(10, pout * 128 + idx)] += outAndTemp[hook(10, pin * 128 + idx - offset)];
  }
  barrier(0x01);
  return outAndTemp[hook(10, 128 - 1)] + in[hook(11, 128 - 1)];
}

unsigned int compactSIMDPrefixSum(local const unsigned int* dsData, local const unsigned int* dsValid, local unsigned int* dsCompact, local unsigned int* dsLocalIndex) {
  unsigned int idx = get_local_id(0);
  unsigned int numValid = exclusivePrescan128(dsValid, dsLocalIndex);
  if (dsValid[hook(12, idx)])
    dsCompact[hook(13, dsLocalIndex[ihook(14, idx))] = dsData[hook(15, idx)];
  return numValid;
}

kernel void moveValidElementsStaged(global unsigned int* restrict result, global const unsigned int* dgData, global unsigned int* restrict dgCompact, global const unsigned int* dgValid, global const unsigned int* restrict dgBlockCounts, local unsigned int* restrict inBlock, local unsigned int* restrict validBlock, local unsigned int* restrict compactBlock, private const unsigned int len) {
  unsigned int idx = get_local_id(0);
  unsigned int gidx = get_group_id(0);
  unsigned int ngrps = get_num_groups(0);
  unsigned int lsize = get_local_size(0);
  local unsigned int dsLocalIndex[256];
  unsigned int blockOutOffset = 0;
  blockOutOffset = dgBlockCounts[hook(4, gidx)];
  const unsigned int epb = len / ngrps + ((len % ngrps) ? 1 : 0);
  const unsigned int ub = (len < (gidx + 1) * epb) ? len : ((gidx + 1) * epb);
  for (unsigned int base = gidx * epb; base < (gidx + 1) * epb; base += lsize) {
    if ((base + idx) < ub) {
      validBlock[hook(6, idx)] = (dgValid[hook(3, base + idx)] != 0);
      inBlock[hook(5, idx)] = dgData[hook(1, base + idx)];
    } else {
      validBlock[hook(6, idx)] = 0;
    }
    barrier(0x01);
    unsigned int numValidBlock = compactSIMDPrefixSum(inBlock, validBlock, compactBlock, dsLocalIndex);
    barrier(0x01);
    if (idx < numValidBlock)
      dgCompact[hook(2, blockOutOffset + idx)] = compactBlock[hook(7, idx)];
    blockOutOffset += numValidBlock;
  }
  barrier(0x01);
  if (gidx == (ngrps - 1) && idx == 0)
    result[hook(0, 0)] = blockOutOffset;
}