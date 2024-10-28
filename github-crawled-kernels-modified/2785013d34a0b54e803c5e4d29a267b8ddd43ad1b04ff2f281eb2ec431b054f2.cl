//{"array":0,"block":2,"higherLevelArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scan_WorkEfficient(global unsigned int* array, global unsigned int* higherLevelArray, local unsigned int* block) {
  int GID = get_global_id(0);
  int LID = get_local_id(0);
  int LSize = get_local_size(0);

  block[hook(2, LID)] = array[hook(0, GID)];
  barrier(0x01);
  for (int stride = 1; stride < LSize; stride *= 2) {
    if ((LID + 1) % (2 * stride) == 0 && LID >= stride)
      block[hook(2, LID)] += block[hook(2, LID - stride)];
    barrier(0x01);
  }
  if (LID == LSize - 1)
    block[hook(2, LSize - 1)] = 0;
  barrier(0x01);

  for (int stride = LSize; stride > 0; stride /= 2) {
    if ((LID + 1) % (2 * stride) == 0) {
      int left = block[hook(2, LID)];
      block[hook(2, LID)] += block[hook(2, LID - stride)];
      block[hook(2, LID - stride)] = left;
    }
    barrier(0x01);
  }
  array[hook(0, GID)] += block[hook(2, LID)];
  if (LID == LSize - 1)
    higherLevelArray[hook(1, get_group_id(0))] = array[hook(0, GID)];
}