//{"inArray":0,"outArray":1,"size":3,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline void swap(unsigned int* a, unsigned int* b) {
  unsigned int tmp;
  tmp = *b;
  *b = *a;
  *a = tmp;
}

inline void sort(unsigned int* a, unsigned int* b, char dir) {
  if ((*a > *b) == dir)
    swap(a, b);
}

inline void swapLocal(local unsigned int* a, local unsigned int* b) {
  unsigned int tmp;
  tmp = *b;
  *b = *a;
  *a = tmp;
}

inline void sortLocal(local unsigned int* a, local unsigned int* b, char dir) {
  if ((*a > *b) == dir)
    swapLocal(a, b);
}

kernel void Sort_MergesortGlobalBig(const global unsigned int* inArray, global unsigned int* outArray, const unsigned int stride, const unsigned int size) {
  const unsigned int baseIndex = get_global_id(0) * stride;
  const char dir = 1;

  unsigned int middle = baseIndex + (stride >> 1);
  unsigned int left = baseIndex;
  unsigned int right = middle;
  bool selectLeft;

  if ((baseIndex + stride) > size)
    return;

  for (unsigned int i = baseIndex; i < (baseIndex + stride); i++) {
    selectLeft = (left < middle && (right == (baseIndex + stride) || inArray[hook(0, left)] <= inArray[hook(0, right)])) == dir;

    outArray[hook(1, i)] = (selectLeft) ? inArray[hook(0, left)] : inArray[hook(0, right)];

    left += selectLeft;
    right += 1 - selectLeft;
  }
}