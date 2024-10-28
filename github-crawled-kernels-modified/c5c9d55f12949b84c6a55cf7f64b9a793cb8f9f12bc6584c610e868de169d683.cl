//{"aCache":4,"aLength":2,"aList":0,"bCache":5,"bLength":3,"bList":1,"gap":6,"keyLength":8,"matches":9,"offset":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cgm_kernel(constant unsigned int* aList, constant unsigned int* bList, int aLength, int bLength, local unsigned int* aCache, local unsigned int* bCache, int gap, int offset, int keyLength, global unsigned int* matches) {
  const size_t workSize_width = get_local_size(0);
  const size_t workSize_height = get_local_size(1);

  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  if (get_local_id(0) == 0 && get_local_id(1) == 0) {
    for (int i = 0; i < workSize_width; i++) {
      for (int j = 0; j < workSize_height; j++) {
        aCache[hook(4, x + i)] = aList[hook(0, x + i)];
        bCache[hook(5, y + j)] = bList[hook(1, y + j)];
      }
    }
  }
  barrier(0x01);

  if (bCache[hook(5, y)] == aCache[hook(4, x)] + keyLength + gap)
    matches[hook(9, x)] = aCache[hook(4, x)] - offset;
}