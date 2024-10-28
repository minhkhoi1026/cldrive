//{"_buf0":0,"count":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int nth_fibonacci(unsigned int n) {
  const float golden_ratio = (1.f + sqrt(5.f)) / 2.f;
  return floor(pown(golden_ratio, n) / sqrt(5.f) + 0.5f);
}

kernel void copy(global unsigned int* _buf0, const unsigned int count) {
  unsigned int index = get_local_id(0) + (32 * get_group_id(0));
  for (unsigned int i = 0; i < 4; i++) {
    if (index < count) {
      _buf0[hook(0, index)] = nth_fibonacci((0 + index));
      index += 8;
    }
  }
}