//{"dataToSort":0,"destinationArray":3,"globalHistogram":10,"histogram":7,"histogramGlobalRadixMajor":1,"histogramLocalGroupMajor":2,"histogramOutputGroupMajor":8,"histogramOutputRadixMajor":9,"localHistogram":11,"prefixSums":6,"sorterLocalMemory":5,"startBit":4}
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
__attribute__((reqd_work_group_size(128, 1, 1))) __attribute__((reqd_work_group_size(128, 1, 1))) __attribute__((reqd_work_group_size(128, 1, 1))) __attribute__((reqd_work_group_size(128, 1, 1))) __attribute__((reqd_work_group_size(128, 1, 1))) kernel void RadixSortGlobal(

    global uint8* dataToSort,

    global unsigned* histogramGlobalRadixMajor, global unsigned* histogramLocalGroupMajor, global uint2* destinationArray, unsigned startBit, local unsigned* sorterLocalMemory) {
  local unsigned* localHistogram = sorterLocalMemory + 2 * (1 << 4);
  local unsigned* globalHistogram = sorterLocalMemory;

  if (get_local_id(0) < ((1 << 4) / 2)) {
    uint2 histElement = (uint2)(get_local_id(0), get_local_id(0) + 8);

    uint2 localValues;
    globalHistogram[hook(10, histElement.x)] = histogramGlobalRadixMajor[hook(1, get_num_groups(0) * histElement.x + get_group_id(0))];
    globalHistogram[hook(10, histElement.y)] = histogramGlobalRadixMajor[hook(1, get_num_groups(0) * histElement.y + get_group_id(0))];

    localValues.x = histogramLocalGroupMajor[hook(2, (1 << 4) * get_group_id(0) + histElement.x)];
    localValues.y = histogramLocalGroupMajor[hook(2, (1 << 4) * get_group_id(0) + histElement.y)];
    localHistogram[hook(11, histElement.x)] = localValues.x;
    localHistogram[hook(11, histElement.y)] = localValues.y;

    localHistogram[hook(11, histElement.x - (1 << 4))] = 0;
    localHistogram[hook(11, histElement.y - (1 << 4))] = 0;

    int idx = 2 * get_local_id(0);
    localHistogram[hook(11, idx)] += localHistogram[hook(11, idx - 1)];
    mem_fence(0x01);
    localHistogram[hook(11, idx)] += localHistogram[hook(11, idx - 2)];
    mem_fence(0x01);
    localHistogram[hook(11, idx)] += localHistogram[hook(11, idx - 4)];
    mem_fence(0x01);
    localHistogram[hook(11, idx)] += localHistogram[hook(11, idx - 8)];
    mem_fence(0x01);

    localHistogram[hook(11, idx - 1)] += localHistogram[hook(11, idx - 2)];
    mem_fence(0x01);

    localValues.x = localHistogram[hook(11, histElement.x - 1)];
    localValues.y = localHistogram[hook(11, histElement.y - 1)];

    localHistogram[hook(11, histElement.x)] = localValues.x;
    localHistogram[hook(11, histElement.y)] = localValues.y;
  }

  barrier(0x01);

  const int numLocalElements = 512;
  uint4 localAddress = (uint4)(get_local_id(0), get_local_id(0), get_local_id(0), get_local_id(0));
  localAddress = localAddress * (unsigned)4;
  uint4 addValues = (uint4)(0, 1, 2, 3);
  localAddress = localAddress + addValues;

  uint4 globalAddress = get_group_id(0);
  globalAddress *= numLocalElements + localAddress;

  uint8 sortValue;
  sortValue = dataToSort[hook(0, globalAddress.x / 4)];

  unsigned int cmpValue = ((1 << 4) - 1);
  uint4 cmpValueVector = (uint4)(cmpValue, cmpValue, cmpValue, cmpValue);
  uint4 radix;

  radix.x = (sortValue.s0 >> startBit);
  radix.y = (sortValue.s2 >> startBit);
  radix.z = (sortValue.s4 >> startBit);
  radix.w = (sortValue.s6 >> startBit);

  radix = radix & cmpValueVector;

  uint4 localOffsetIntoRadixSet;
  localOffsetIntoRadixSet = localAddress;
  localOffsetIntoRadixSet.x = localOffsetIntoRadixSet.x - localHistogram[hook(11, radix.x)];
  localOffsetIntoRadixSet.y = localOffsetIntoRadixSet.y - localHistogram[hook(11, radix.y)];
  localOffsetIntoRadixSet.z = localOffsetIntoRadixSet.z - localHistogram[hook(11, radix.z)];
  localOffsetIntoRadixSet.w = localOffsetIntoRadixSet.w - localHistogram[hook(11, radix.w)];

  uint4 globalOffset = localOffsetIntoRadixSet;
  globalOffset.x = globalOffset.x + globalHistogram[hook(10, radix.x)];
  globalOffset.y = globalOffset.y + globalHistogram[hook(10, radix.y)];
  globalOffset.z = globalOffset.z + globalHistogram[hook(10, radix.z)];
  globalOffset.w = globalOffset.w + globalHistogram[hook(10, radix.w)];

  destinationArray[hook(3, globalOffset.x)] = (uint2)(sortValue.s0, sortValue.s1);
  destinationArray[hook(3, globalOffset.y)] = (uint2)(sortValue.s2, sortValue.s3);
  destinationArray[hook(3, globalOffset.z)] = (uint2)(sortValue.s4, sortValue.s5);
  destinationArray[hook(3, globalOffset.w)] = (uint2)(sortValue.s6, sortValue.s7);
}