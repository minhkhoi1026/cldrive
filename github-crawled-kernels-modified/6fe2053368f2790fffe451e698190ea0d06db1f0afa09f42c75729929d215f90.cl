//{"arr":9,"compactBlock":8,"dNumValidElements":5,"dgBlockCounts":3,"dgCompact":1,"dgData":0,"dgValid":2,"dsCompact":14,"dsData":16,"dsLocalIndex":15,"dsValid":13,"in":11,"inBlock":6,"len":4,"outAndTemp":12,"temp":10,"validBlock":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int sumReduce128(local unsigned int* arr) {
  int thread = get_local_id(0);
  if (thread < 64)
    arr[hook(9, thread)] += arr[hook(9, thread + 64)];
  barrier(0x01);
  if (thread < 32)
    arr[hook(9, thread)] += arr[hook(9, thread + 32)];
  barrier(0x01);
  if (thread < 16)
    arr[hook(9, thread)] += arr[hook(9, thread + 16)];
  barrier(0x01);
  if (thread < 8)
    arr[hook(9, thread)] += arr[hook(9, thread + 8)];
  barrier(0x01);
  if (thread < 4)
    arr[hook(9, thread)] += arr[hook(9, thread + 4)];
  barrier(0x01);
  if (thread < 2)
    arr[hook(9, thread)] += arr[hook(9, thread + 2)];
  barrier(0x01);
  if (thread < 1)
    arr[hook(9, thread)] += arr[hook(9, thread + 1)];

  barrier(0x01);
  return arr[hook(9, 0)];
}

int exclusivePrescan128(local const unsigned int* in, local unsigned int* outAndTemp) {
  const int n = 128;

  local unsigned int* temp = outAndTemp;
  int pout = 1, pin = 0;

  int thread = get_local_id(0);
  temp[hook(10, pout * n + get_local_id(0))] = (get_local_id(0) > 0) ? in[hook(11, get_local_id(0) - 1)] : 0;
  barrier(0x01);

  for (int offset = 1; offset < n; offset *= 2) {
    pout = 1 - pout;
    pin = 1 - pout;
    barrier(0x01);
    temp[hook(10, pout * n + get_local_id(0))] = temp[hook(10, pin * n + get_local_id(0))];
    if (get_local_id(0) >= offset)
      temp[hook(10, pout * n + get_local_id(0))] += temp[hook(10, pin * n + get_local_id(0) - offset)];
  }

  barrier(0x01);
  return outAndTemp[hook(12, 127)] + in[hook(11, 127)];
}

int compactSIMDPrefixSum(local const unsigned int* dsData, local const unsigned int* dsValid, local unsigned int* dsCompact, local unsigned int* dsLocalIndex) {
  int numValid = exclusivePrescan128(dsValid, dsLocalIndex);
  int thread = get_local_id(0);
  if (dsValid[hook(13, get_local_id(0))])
    dsCompact[hook(14, dsLocalIndex[ghook(15, get_local_id(0)))] = dsData[hook(16, get_local_id(0))];
  return numValid;
}

kernel void moveValidElementsStaged(global const unsigned int* restrict dgData, global unsigned int* restrict dgCompact, global const unsigned int* restrict dgValid, global const unsigned int* restrict dgBlockCounts, unsigned int len, global unsigned int* restrict dNumValidElements, local unsigned int* restrict inBlock, local unsigned int* restrict validBlock, local unsigned int* restrict compactBlock) {
  local unsigned int dsLocalIndex[256];
  int blockOutOffset = 0;

  int thread = get_local_id(0);
  for (int base = 0; base < get_group_id(0); base += get_local_size(0)) {
    if ((base + get_local_id(0)) < get_group_id(0)) {
      validBlock[hook(7, get_local_id(0))] = dgBlockCounts[hook(3, base + get_local_id(0))];
    } else {
      validBlock[hook(7, get_local_id(0))] = 0;
    }
    barrier(0x01);

    blockOutOffset += sumReduce128(validBlock);
    barrier(0x01);
  }

  unsigned int ub;
  const unsigned int eltsPerBlock = len / get_num_groups(0) + ((len % get_num_groups(0)) ? 1 : 0);
  ub = (len < (get_group_id(0) + 1) * eltsPerBlock) ? len : ((get_group_id(0) + 1) * eltsPerBlock);
  for (int base = get_group_id(0) * eltsPerBlock; base < (get_group_id(0) + 1) * eltsPerBlock; base += get_local_size(0)) {
    if ((base + get_local_id(0)) < ub) {
      validBlock[hook(7, get_local_id(0))] = dgValid[hook(2, base + get_local_id(0))];
      inBlock[hook(6, get_local_id(0))] = dgData[hook(0, base + get_local_id(0))];
    } else {
      validBlock[hook(7, get_local_id(0))] = 0;
    }
    barrier(0x01);
    int numValidBlock = compactSIMDPrefixSum(inBlock, validBlock, compactBlock, dsLocalIndex);
    barrier(0x01);
    if (get_local_id(0) < numValidBlock) {
      dgCompact[hook(1, blockOutOffset + get_local_id(0))] = compactBlock[hook(8, get_local_id(0))];
    }
    blockOutOffset += numValidBlock;
  }
  if (get_group_id(0) == (get_num_groups(0) - 1) && get_local_id(0) == 0) {
    *dNumValidElements = blockOutOffset;
  }
}