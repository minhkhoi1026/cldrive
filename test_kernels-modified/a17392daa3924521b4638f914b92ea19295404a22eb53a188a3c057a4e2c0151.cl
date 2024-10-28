//{"data":5,"key_lds":3,"key_ptr":0,"val_lds":4,"value_ptr":1,"vecSize":2}
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
    float midValue = data[hook(5, midIndex)];

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
    float upperValue = data[hook(5, upperBound)];
    while (!((upperValue) < (searchVal)) && !((searchVal) < (upperValue)) && (upperBound != right)) {
      upperBound++;
      upperValue = data[hook(5, upperBound)];
    }
  }

  return upperBound;
}

kernel void blockInsertionSort(global float* key_ptr, global float* value_ptr, const unsigned int vecSize, local float* key_lds, local float* val_lds) {
  int gloId = get_global_id(0);
  int groId = get_group_id(0);
  int locId = get_local_id(0);
  int wgSize = get_local_size(0);

  bool in_range = gloId < (int)vecSize;
  float key;
  float val;

  if (in_range) {
    key = key_ptr[hook(0, gloId)];
    val = value_ptr[hook(1, gloId)];
    key_lds[hook(3, locId)] = key;
    val_lds[hook(4, locId)] = val;
  }
  barrier(0x01);

  if (locId == 0 && in_range) {
    int endIndex = vecSize - (groId * wgSize);
    endIndex = min(endIndex, wgSize);

    for (int currIndex = 1; currIndex < endIndex; ++currIndex) {
      key = key_lds[hook(3, currIndex)];
      val = val_lds[hook(4, currIndex)];
      int scanIndex = currIndex;
      float ldsKey = key_lds[hook(3, scanIndex - 1)];
      while (scanIndex > 0 && ((key) < (ldsKey))) {
        float ldsVal = val_lds[hook(4, scanIndex - 1)];

        key_lds[hook(3, scanIndex)] = ldsKey;
        val_lds[hook(4, scanIndex)] = ldsVal;

        scanIndex = scanIndex - 1;
        ldsKey = key_lds[hook(3, max(0, scanIndex - 1))];
      }
      key_lds[hook(3, scanIndex)] = key;
      val_lds[hook(4, scanIndex)] = val;
    }
  }
  barrier(0x01);

  if (in_range) {
    key = key_lds[hook(3, locId)];
    key_ptr[hook(0, gloId)] = key;

    val = val_lds[hook(4, locId)];
    value_ptr[hook(1, gloId)] = val;
  }
}