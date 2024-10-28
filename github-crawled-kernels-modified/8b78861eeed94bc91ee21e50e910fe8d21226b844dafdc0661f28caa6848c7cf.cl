//{"dataToSort":0,"histogram":7,"histogramOutputGlobalRadixMajor":1,"histogramOutputGroupMajor":8,"histogramOutputLocalGroupMajor":2,"histogramOutputRadixMajor":9,"numGroups":4,"prefixSums":6,"sorterSharedMemory":5,"startBit":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef uint2 uint2;
void localPrefixSum(local unsigned* prefixSums, unsigned numElements) {
  int offset = 1;

  for (int level = numElements >> 1; level > 0; level >>= 1)

  {
    barrier(0x01);

    for (int sumElement = get_local_id(0); sumElement < level; sumElement += get_local_size(0)) {
      int i = 2 * offset * sumElement;
      int ai = i + offset - 1;
      int bi = ai + offset;

      ai = (ai);
      bi = (bi);
      prefixSums[hook(6, bi)] += prefixSums[hook(6, ai)];
    }
    offset <<= 1;
  }

  barrier(0x01);

  if (get_local_id(0) == 0)
    prefixSums[hook(6, (numElements - 1))] = 0;

  for (int level = 1; level < numElements; level <<= 1) {
    offset >>= 1;
    barrier(0x01);

    for (int sumElement = get_local_id(0); sumElement < level; sumElement += get_local_size(0)) {
      int ai = offset * (2 * sumElement + 1) - 1;
      int bi = offset * (2 * sumElement + 2) - 1;

      ai = (ai);
      bi = (bi);
      unsigned temporary = prefixSums[hook(6, ai)];
      prefixSums[hook(6, ai)] = prefixSums[hook(6, bi)];
      prefixSums[hook(6, bi)] += temporary;
    }
  }
}

void BClocalPF(local unsigned* prefixSums) {
  int offset = 1;

  for (int level = 8; level > 0; level >>= 1) {
    for (int sumElement = get_local_id(0); sumElement < level; sumElement += get_local_size(0)) {
      int ai = offset * (2 * sumElement + 1) - 1;
      int bi = offset * (2 * sumElement + 2) - 1;
      prefixSums[hook(6, bi)] += prefixSums[hook(6, ai)];
    }
    offset <<= 1;
  }

  if (get_local_id(0) == 0)
    prefixSums[hook(6, 15)] = 0;

  for (int level = 1; level < 16; level <<= 1) {
    offset >>= 1;

    for (int sumElement = get_local_id(0); sumElement < level; sumElement += get_local_size(0)) {
      int ai = offset * (2 * sumElement + 1) - 1;
      int bi = offset * (2 * sumElement + 2) - 1;
      unsigned temporary = prefixSums[hook(6, ai)];
      prefixSums[hook(6, ai)] = prefixSums[hook(6, bi)];
      prefixSums[hook(6, bi)] += temporary;
    }
  }
}
uint4 localPrefixSumBlock(uint4 prefixSumData, local unsigned* prefixSums) {
  uint4 originalData = prefixSumData;

  prefixSumData.y += prefixSumData.x;
  prefixSumData.w += prefixSumData.z;

  prefixSumData.z += prefixSumData.y;
  prefixSumData.w += prefixSumData.y;

  prefixSums[hook(6, get_local_id(0))] = 0;
  prefixSums[hook(6, get_local_id(0) + 128)] = prefixSumData.w;

  barrier(0x01);
  if (get_local_id(0) < 64) {
    int idx = 2 * get_local_id(0) + 129;
    prefixSums[hook(6, idx)] += prefixSums[hook(6, idx - 1)];
    mem_fence(0x01);
    prefixSums[hook(6, idx)] += prefixSums[hook(6, idx - 2)];
    mem_fence(0x01);
    prefixSums[hook(6, idx)] += prefixSums[hook(6, idx - 4)];
    mem_fence(0x01);
    prefixSums[hook(6, idx)] += prefixSums[hook(6, idx - 8)];
    mem_fence(0x01);
    prefixSums[hook(6, idx)] += prefixSums[hook(6, idx - 16)];
    mem_fence(0x01);
    prefixSums[hook(6, idx)] += prefixSums[hook(6, idx - 32)];
    mem_fence(0x01);
    prefixSums[hook(6, idx)] += prefixSums[hook(6, idx - 64)];
    mem_fence(0x01);

    prefixSums[hook(6, idx - 1)] += prefixSums[hook(6, idx - 2)];
  }
  barrier(0x01);

  unsigned int addValue = prefixSums[hook(6, get_local_id(0) + 127)];

  prefixSumData += (uint4)(addValue, addValue, addValue, addValue);

  return prefixSumData - originalData;
}
void generateHistogram(uint4 sortedData, local unsigned* histogram, global unsigned* histogramOutputRadixMajor, global unsigned* histogramOutputGroupMajor, unsigned startBit, unsigned numGroups) {
  uint4 addresses;
  addresses = (uint4)(get_local_id(0), get_local_id(0), get_local_id(0), get_local_id(0));

  if (get_local_id(0) < (1 << 4)) {
    histogram[hook(7, addresses.x)] = 0;
  }

  addresses = addresses * (unsigned)4;
  addresses.y = addresses.y + 1;
  addresses.z = addresses.z + 2;
  addresses.w = addresses.w + 3;

  sortedData.x >>= startBit;
  sortedData.y >>= startBit;
  sortedData.z >>= startBit;
  sortedData.w >>= startBit;

  int andValue = ((1 << 4) - 1);
  sortedData &= (uint4)(andValue, andValue, andValue, andValue);
  barrier(0x01);
  atom_inc(&(histogram[hook(7, sortedData.x)]));
  atom_inc(&(histogram[hook(7, sortedData.y)]));
  atom_inc(&(histogram[hook(7, sortedData.z)]));
  atom_inc(&(histogram[hook(7, sortedData.w)]));

  barrier(0x01);

  if (get_local_id(0) < 16) {
    unsigned int histValues;

    histValues = histogram[hook(7, get_local_id(0))];

    unsigned globalOffset = 16 * get_group_id(0);
    unsigned int globalAddresses = get_local_id(0) + globalOffset;

    unsigned int globalAddressesRadixMajor = numGroups;
    globalAddressesRadixMajor = globalAddressesRadixMajor * get_local_id(0);
    globalAddressesRadixMajor = globalAddressesRadixMajor + get_group_id(0);

    histogramOutputGroupMajor[hook(8, globalAddresses)] = histValues;
    histogramOutputRadixMajor[hook(9, globalAddressesRadixMajor)] = histValues;
  }
}
__attribute__((reqd_work_group_size(128, 1, 1))) kernel void RadixSortLocal(

    global uint8* dataToSort,

    global unsigned* histogramOutputGlobalRadixMajor, global unsigned* histogramOutputLocalGroupMajor, int startBit, int numGroups, local unsigned* sorterSharedMemory) {
  int numLocalElements = get_local_size(0) * 4;

  uint4 plainLocalAddress = (uint4)(get_local_id(0), get_local_id(0), get_local_id(0), get_local_id(0));
  uint4 addValues = (uint4)(0, 1, 2, 3);
  plainLocalAddress = plainLocalAddress * (unsigned)4;
  plainLocalAddress = plainLocalAddress + addValues;

  uint4 localAddress = (plainLocalAddress);

  uint4 localKeys;
  uint4 localValues;
  {
    uint4 globalAddress = (uint4)(get_group_id(0), get_group_id(0), get_group_id(0), get_group_id(0));
    uint4 localElementsCount = (uint4)(numLocalElements, numLocalElements, numLocalElements, numLocalElements);
    globalAddress = globalAddress * localElementsCount + localAddress;

    uint8 localData;
    localData = dataToSort[hook(0, globalAddress.x / 4)];
    localKeys.s0 = localData.s0;
    localKeys.s1 = localData.s2;
    localKeys.s2 = localData.s4;
    localKeys.s3 = localData.s6;
    localValues.s0 = localData.s1;
    localValues.s1 = localData.s3;
    localValues.s2 = localData.s5;
    localValues.s3 = localData.s7;
  }

  int bitIndex = startBit;
  do {
    if (get_local_id(0) == (get_local_size(0) - 1))
      sorterSharedMemory[hook(5, 256)] = localKeys.w;

    unsigned compare = (1 << bitIndex);
    uint4 compareVec = (uint4)(compare, compare, compare, compare);

    uint4 localCompareVec = localKeys & compareVec;

    uint4 prefixSum;
    prefixSum = select((uint4)(1, 1, 1, 1), (uint4)(0, 0, 0, 0), localCompareVec != (uint4)(0, 0, 0, 0));

    prefixSum = localPrefixSumBlock(prefixSum, sorterSharedMemory);

    unsigned int totalFalses = sorterSharedMemory[hook(5, 255)];

    {
      uint4 localCompareVec = localKeys & compareVec;

      uint4 newAddress = plainLocalAddress - prefixSum;
      newAddress += (uint4)(totalFalses, totalFalses, totalFalses, totalFalses);

      newAddress = select(prefixSum, newAddress, localCompareVec != (uint4)(0, 0, 0, 0));

      newAddress = (newAddress);

      barrier(0x01);

      sorterSharedMemory[hook(5, newAddress.x)] = localKeys.x;
      sorterSharedMemory[hook(5, newAddress.y)] = localKeys.y;
      sorterSharedMemory[hook(5, newAddress.z)] = localKeys.z;
      sorterSharedMemory[hook(5, newAddress.w)] = localKeys.w;

      barrier(0x01);

      localKeys.x = sorterSharedMemory[hook(5, localAddress.x)];
      localKeys.y = sorterSharedMemory[hook(5, localAddress.y)];
      localKeys.z = sorterSharedMemory[hook(5, localAddress.z)];
      localKeys.w = sorterSharedMemory[hook(5, localAddress.w)];

      barrier(0x01);

      sorterSharedMemory[hook(5, newAddress.x)] = localValues.x;
      sorterSharedMemory[hook(5, newAddress.y)] = localValues.y;
      sorterSharedMemory[hook(5, newAddress.z)] = localValues.z;
      sorterSharedMemory[hook(5, newAddress.w)] = localValues.w;

      barrier(0x01);

      localValues.x = sorterSharedMemory[hook(5, localAddress.x)];
      localValues.y = sorterSharedMemory[hook(5, localAddress.y)];
      localValues.z = sorterSharedMemory[hook(5, localAddress.z)];
      localValues.w = sorterSharedMemory[hook(5, localAddress.w)];

      barrier(0x01);
    }

    bitIndex = bitIndex + 1;
  } while (bitIndex < (startBit + 4));

  generateHistogram(localKeys, sorterSharedMemory, histogramOutputGlobalRadixMajor, histogramOutputLocalGroupMajor, startBit, numGroups);

  {
    uint4 globalAddress = (uint4)(get_group_id(0), get_group_id(0), get_group_id(0), get_group_id(0));
    uint4 localElementsCount = (uint4)(numLocalElements, numLocalElements, numLocalElements, numLocalElements);
    globalAddress = globalAddress * localElementsCount + plainLocalAddress;

    uint8 localData;
    localData.s0 = localKeys.s0;
    localData.s2 = localKeys.s1;
    localData.s4 = localKeys.s2;
    localData.s6 = localKeys.s3;
    localData.s1 = localValues.s0;
    localData.s3 = localValues.s1;
    localData.s5 = localValues.s2;
    localData.s7 = localValues.s3;

    dataToSort[hook(0, globalAddress.x / 4)] = localData;
  }
}