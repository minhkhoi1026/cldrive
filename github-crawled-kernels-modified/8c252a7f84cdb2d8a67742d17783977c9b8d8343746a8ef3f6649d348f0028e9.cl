//{"aLength":2,"aList":0,"bLength":3,"bList":1,"gap":4,"keyLength":6,"matches":7,"offset":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cgm_kernel(global unsigned int* aList, global unsigned int* bList, int aLength, int bLength, int gap, int offset, int keyLength, global unsigned int* matches) {
  const size_t x = get_global_id(0);
  const size_t y = get_global_id(1);

  if (bList[hook(1, y)] == aList[hook(0, x)] + keyLength + gap)
    matches[hook(7, x)] = aList[hook(0, x)] - offset;
}