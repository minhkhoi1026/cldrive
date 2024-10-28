//{"block_size":1,"histogram":5,"histogramOutputGroupMajor":6,"histogramOutputRadixMajor":7,"length":2,"prefixSums":4,"scanArray":0,"sumBuffer":3}
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
      prefixSums[hook(4, bi)] += prefixSums[hook(4, ai)];
    }
    offset <<= 1;
  }

  barrier(0x01);

  if (get_local_id(0) == 0)
    prefixSums[hook(4, (numElements - 1))] = 0;

  for (int level = 1; level < numElements; level <<= 1) {
    offset >>= 1;
    barrier(0x01);

    for (int sumElement = get_local_id(0); sumElement < level; sumElement += get_local_size(0)) {
      int ai = offset * (2 * sumElement + 1) - 1;
      int bi = offset * (2 * sumElement + 2) - 1;

      ai = (ai);
      bi = (bi);
      unsigned temporary = prefixSums[hook(4, ai)];
      prefixSums[hook(4, ai)] = prefixSums[hook(4, bi)];
      prefixSums[hook(4, bi)] += temporary;
    }
  }
}

void BClocalPF(local unsigned* prefixSums) {
  int offset = 1;

  for (int level = 8; level > 0; level >>= 1) {
    for (int sumElement = get_local_id(0); sumElement < level; sumElement += get_local_size(0)) {
      int ai = offset * (2 * sumElement + 1) - 1;
      int bi = offset * (2 * sumElement + 2) - 1;
      prefixSums[hook(4, bi)] += prefixSums[hook(4, ai)];
    }
    offset <<= 1;
  }

  if (get_local_id(0) == 0)
    prefixSums[hook(4, 15)] = 0;

  for (int level = 1; level < 16; level <<= 1) {
    offset >>= 1;

    for (int sumElement = get_local_id(0); sumElement < level; sumElement += get_local_size(0)) {
      int ai = offset * (2 * sumElement + 1) - 1;
      int bi = offset * (2 * sumElement + 2) - 1;
      unsigned temporary = prefixSums[hook(4, ai)];
      prefixSums[hook(4, ai)] = prefixSums[hook(4, bi)];
      prefixSums[hook(4, bi)] += temporary;
    }
  }
}
uint4 localPrefixSumBlock(uint4 prefixSumData, local unsigned* prefixSums) {
  uint4 originalData = prefixSumData;

  prefixSumData.y += prefixSumData.x;
  prefixSumData.w += prefixSumData.z;

  prefixSumData.z += prefixSumData.y;
  prefixSumData.w += prefixSumData.y;

  prefixSums[hook(4, get_local_id(0))] = 0;
  prefixSums[hook(4, get_local_id(0) + 128)] = prefixSumData.w;

  barrier(0x01);
  if (get_local_id(0) < 64) {
    int idx = 2 * get_local_id(0) + 129;
    prefixSums[hook(4, idx)] += prefixSums[hook(4, idx - 1)];
    mem_fence(0x01);
    prefixSums[hook(4, idx)] += prefixSums[hook(4, idx - 2)];
    mem_fence(0x01);
    prefixSums[hook(4, idx)] += prefixSums[hook(4, idx - 4)];
    mem_fence(0x01);
    prefixSums[hook(4, idx)] += prefixSums[hook(4, idx - 8)];
    mem_fence(0x01);
    prefixSums[hook(4, idx)] += prefixSums[hook(4, idx - 16)];
    mem_fence(0x01);
    prefixSums[hook(4, idx)] += prefixSums[hook(4, idx - 32)];
    mem_fence(0x01);
    prefixSums[hook(4, idx)] += prefixSums[hook(4, idx - 64)];
    mem_fence(0x01);

    prefixSums[hook(4, idx - 1)] += prefixSums[hook(4, idx - 2)];
  }
  barrier(0x01);

  unsigned int addValue = prefixSums[hook(4, get_local_id(0) + 127)];

  prefixSumData += (uint4)(addValue, addValue, addValue, addValue);

  return prefixSumData - originalData;
}
void generateHistogram(uint4 sortedData, local unsigned* histogram, global unsigned* histogramOutputRadixMajor, global unsigned* histogramOutputGroupMajor, unsigned startBit, unsigned numGroups) {
  uint4 addresses;
  addresses = (uint4)(get_local_id(0), get_local_id(0), get_local_id(0), get_local_id(0));

  if (get_local_id(0) < (1 << 4)) {
    histogram[hook(5, addresses.x)] = 0;
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
  atom_inc(&(histogram[hook(5, sortedData.x)]));
  atom_inc(&(histogram[hook(5, sortedData.y)]));
  atom_inc(&(histogram[hook(5, sortedData.z)]));
  atom_inc(&(histogram[hook(5, sortedData.w)]));

  barrier(0x01);

  if (get_local_id(0) < 16) {
    unsigned int histValues;

    histValues = histogram[hook(5, get_local_id(0))];

    unsigned globalOffset = 16 * get_group_id(0);
    unsigned int globalAddresses = get_local_id(0) + globalOffset;

    unsigned int globalAddressesRadixMajor = numGroups;
    globalAddressesRadixMajor = globalAddressesRadixMajor * get_local_id(0);
    globalAddressesRadixMajor = globalAddressesRadixMajor + get_group_id(0);

    histogramOutputGroupMajor[hook(6, globalAddresses)] = histValues;
    histogramOutputRadixMajor[hook(7, globalAddressesRadixMajor)] = histValues;
  }
}
__attribute__((reqd_work_group_size(128, 1, 1))) __attribute__((reqd_work_group_size(128, 1, 1))) __attribute__((reqd_work_group_size(128, 1, 1))) kernel void ScanPropagateBlockSums(global unsigned int* scanArray, const unsigned int block_size, const unsigned int length, global unsigned int* sumBuffer) {
  unsigned int blockSum = sumBuffer[hook(3, get_group_id(0) + 1)];

  unsigned int left = (get_group_id(0) + 2) * (block_size);
  int endValue = min(left, length);

  for (int i = (get_group_id(0) + 1) * block_size + get_local_id(0); i < endValue; i += get_local_size(0)) {
    scanArray[hook(0, i)] += blockSum;
  }
}