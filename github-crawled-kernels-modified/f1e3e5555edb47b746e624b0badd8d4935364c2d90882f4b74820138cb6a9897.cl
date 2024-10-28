//{"data":8,"iKey_ptr":0,"iValue_ptr":1,"key_lds":6,"oKey_ptr":2,"oValue_ptr":3,"srcLogicalBlockSize":5,"srcVecSize":4,"val_lds":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int lowerBoundBinary(global float* data, unsigned int left, unsigned int right, float searchVal) {
  unsigned int firstIndex = left;
  unsigned int lastIndex = right;

  while (firstIndex < lastIndex) {
    unsigned int midIndex = (firstIndex + lastIndex) / 2;
    float midValue = data[hook(8, midIndex)];

    if (((midValue) < (searchVal))) {
      firstIndex = midIndex + 1;

    } else {
      lastIndex = midIndex;
    }
  }

  return firstIndex;
}

inline unsigned int upperBoundBinary(global float* data, unsigned int left, unsigned int right, float searchVal) {
  unsigned int upperBound = lowerBoundBinary(data, left, right, searchVal);

  if (upperBound != right) {
    float upperValue = data[hook(8, upperBound)];
    while (!((upperValue) < (searchVal)) && !((searchVal) < (upperValue)) && (upperBound != right)) {
      upperBound++;
      upperValue = data[hook(8, upperBound)];
    }
  }

  return upperBound;
}

kernel void merge(global float* iKey_ptr, global float* iValue_ptr, global float* oKey_ptr, global float* oValue_ptr, const unsigned int srcVecSize, const unsigned int srcLogicalBlockSize, local float* key_lds, local float* val_lds) {
  size_t globalID = get_global_id(0);

  if (globalID >= srcVecSize)
    return;

  unsigned int srcBlockNum = globalID / srcLogicalBlockSize;
  unsigned int srcBlockIndex = globalID % srcLogicalBlockSize;

  unsigned int dstLogicalBlockSize = srcLogicalBlockSize << 1;
  unsigned int leftBlockIndex = globalID & ~((dstLogicalBlockSize)-1);
  leftBlockIndex += (srcBlockNum & 0x1) ? 0 : srcLogicalBlockSize;
  leftBlockIndex = min(leftBlockIndex, srcVecSize);
  unsigned int rightBlockIndex = min(leftBlockIndex + srcLogicalBlockSize, srcVecSize);
  unsigned int insertionIndex = 0;
  if ((srcBlockNum & 0x1) == 0) {
    insertionIndex = lowerBoundBinary(iKey_ptr, leftBlockIndex, rightBlockIndex, iKey_ptr[hook(0, globalID)]) - leftBlockIndex;
  } else {
    insertionIndex = upperBoundBinary(iKey_ptr, leftBlockIndex, rightBlockIndex, iKey_ptr[hook(0, globalID)]) - leftBlockIndex;
  }

  unsigned int dstBlockIndex = srcBlockIndex + insertionIndex;
  unsigned int dstBlockNum = srcBlockNum / 2;

  oKey_ptr[hook(2, (dstBlockNum * dstLogicalBlockSize) + dstBlockIndex)] = iKey_ptr[hook(0, globalID)];
  oValue_ptr[hook(3, (dstBlockNum * dstLogicalBlockSize) + dstBlockIndex)] = iValue_ptr[hook(1, globalID)];
}