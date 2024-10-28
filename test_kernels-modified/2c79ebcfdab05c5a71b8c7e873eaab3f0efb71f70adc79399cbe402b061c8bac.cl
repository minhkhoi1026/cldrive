//{"blockOffsets":0,"elements":1,"numElements":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addOffset(const global unsigned int* blockOffsets, global unsigned int* elements, unsigned int numElements) {
  const unsigned int gid0 = get_global_id(0);

  if (gid0 < numElements)
    elements[hook(1, gid0)] += blockOffsets[hook(0, (get_global_offset(0) / 128) + get_group_id(0))];
}