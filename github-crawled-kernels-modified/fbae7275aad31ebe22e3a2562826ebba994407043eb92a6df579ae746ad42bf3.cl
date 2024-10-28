//{"haystack":0,"haystackSize":1,"needlesArr":2,"needlesArrSize":3,"windowSizes":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef long long;
kernel void binarySearch_classic(const global long* haystack, const int haystackSize, global long* needlesArr, const int needlesArrSize, const global int* windowSizes) {
  size_t global_id = get_global_id(0);
  if (global_id >= needlesArrSize) {
    return;
  }

  long needle = 0, curValue = 0, low = 0, high = haystackSize - 1, mid = 0, firstOccurrenceOffset;

  long filter = ((long)0 - 1) << (62 - windowSizes[hook(4, global_id)] * 2);
  needle = needlesArr[hook(2, global_id)] & filter;

  if (needle < (haystack[hook(0, low)] & filter)) {
    needlesArr[hook(2, global_id)] = -1;
    return;
  }

  if (needle > (haystack[hook(0, high)] & filter)) {
    needlesArr[hook(2, global_id)] = -1;
    return;
  }

  if (needle == (haystack[hook(0, low)] & filter)) {
    needlesArr[hook(2, global_id)] = 0;
    return;
  }

  mid = haystackSize / 2;
  curValue = haystack[hook(0, mid)] & filter;

  for (int j = 0; low <= high && curValue != needle; j++) {
    if (needle > curValue) {
      low = mid + 1;
    } else {
      high = mid - 1;
    }
    mid = low + (high - low) / 2;
    curValue = haystack[hook(0, mid)] & filter;
  }

  if (curValue == needle) {
    for (firstOccurrenceOffset = mid; firstOccurrenceOffset >= 0 && (haystack[hook(0, firstOccurrenceOffset)] & filter) == needle; firstOccurrenceOffset--) {
    };

    needlesArr[hook(2, global_id)] = firstOccurrenceOffset + 1;
  } else {
    needlesArr[hook(2, global_id)] = -1;
  }
}