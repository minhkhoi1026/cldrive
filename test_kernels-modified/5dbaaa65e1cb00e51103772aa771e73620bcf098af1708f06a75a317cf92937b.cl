//{"block":2,"block_size":3,"histogram":7,"histogramOutputGroupMajor":8,"histogramOutputRadixMajor":9,"input":1,"length":4,"output":0,"prefixSums":6,"sumBuffer":5}
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
__attribute__((reqd_work_group_size(128, 1, 1))) __attribute__((reqd_work_group_size(128, 1, 1))) kernel void ScanLargeArrays(global unsigned int* output, global unsigned int* input, local unsigned int* block, const unsigned int block_size, const unsigned int length, global unsigned int* sumBuffer)

{
  int tid = get_local_id(0);
  int gid = get_global_id(0);
  int bid = get_group_id(0);

  int offset = 1;

  if ((2 * gid + 1) < length) {
    block[hook(2, 2 * tid)] = input[hook(1, 2 * gid)];
    block[hook(2, 2 * tid + 1)] = input[hook(1, 2 * gid + 1)];
  } else {
    block[hook(2, 2 * tid)] = 0;
    block[hook(2, 2 * tid + 1)] = 0;
  }

  for (int d = block_size >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      block[hook(2, bi)] += block[hook(2, ai)];
    }
    offset *= 2;
  }

  barrier(0x01);

  sumBuffer[hook(5, bid)] = block[hook(2, block_size - 1)];

  barrier(0x01 | 0x02);

  block[hook(2, block_size - 1)] = 0;

  for (int d = 1; d < block_size; d *= 2) {
    offset >>= 1;
    barrier(0x01);

    if (tid < d) {
      int ai = offset * (2 * tid + 1) - 1;
      int bi = offset * (2 * tid + 2) - 1;

      unsigned int t = block[hook(2, ai)];
      block[hook(2, ai)] = block[hook(2, bi)];
      block[hook(2, bi)] += t;
    }
  }

  barrier(0x01);

  if ((2 * gid + 1) < length) {
    output[hook(0, 2 * gid)] = block[hook(2, 2 * tid)];
    output[hook(0, 2 * gid + 1)] = block[hook(2, 2 * tid + 1)];
  }
}