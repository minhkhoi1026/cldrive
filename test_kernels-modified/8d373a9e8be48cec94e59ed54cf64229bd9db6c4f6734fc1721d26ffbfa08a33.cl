//{"inArray":0,"offset":2,"outArray":1,"size":3}
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

kernel void Sort_SimpleSortingNetwork(const global unsigned int* inArray, global unsigned int* outArray, const unsigned int offset, const unsigned int size) {
  const unsigned int index = (get_global_id(0) << 1) + offset;
  if (index + 1 >= size)
    return;

  unsigned int left = inArray[hook(0, index)];
  unsigned int right = inArray[hook(0, index + 1)];
  sort(&left, &right, 1);
  outArray[hook(1, index)] = left;
  outArray[hook(1, index + 1)] = right;
}