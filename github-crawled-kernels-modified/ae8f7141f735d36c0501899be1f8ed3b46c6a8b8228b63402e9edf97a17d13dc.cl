//{"blocksize":2,"data":0,"size":1,"stride":3}
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

kernel void Sort_BitonicMergesortGlobal(global unsigned int* data, const unsigned int size, const unsigned int blocksize, const unsigned int stride) {
  unsigned int gid = get_global_id(0);
  unsigned int clampedGID = gid & (size / 2 - 1);

  unsigned int index = 2 * clampedGID - (clampedGID & (stride - 1));
  char dir = (clampedGID & (blocksize / 2)) == 0;

  unsigned int left = data[hook(0, index)];
  unsigned int right = data[hook(0, index + stride)];

  sort(&left, &right, dir);

  data[hook(0, index)] = left;
  data[hook(0, index + stride)] = right;
}