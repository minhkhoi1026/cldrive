//{"aLength":2,"aList":0,"bLength":3,"bList":1,"gap":4,"keyLength":6,"matches":7,"offset":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cgm_kernel(global unsigned int* aList, global unsigned int* bList, int aLength, int bLength, int gap, int offset, int keyLength, global unsigned int* matches) {
  const size_t width = get_global_size(0);
  const size_t length = get_global_size(1);
  const size_t x = get_global_id(0);
  const size_t y = get_global_id(1);
  const size_t index = x + y * width;

  int i = index;

  while (i < aLength) {
    matches[hook(7, i)] = 0;

    int lower = 0;
    int upper = bLength - 1;

    while (lower <= upper) {
      int j = (upper + lower) / 2;
      if (bList[hook(1, j)] == aList[hook(0, i)] + keyLength + gap) {
        matches[hook(7, i)] = aList[hook(0, i)] - offset;
        break;
      } else if (bList[hook(1, j)] > aList[hook(0, i)] + keyLength + gap)
        upper = j - 1;
      else
        lower = j + 1;
    }

    i += width * length;
  }
}