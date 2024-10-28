//{"globalArray":0,"length":1,"step":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ReverseUpdate(global int* globalArray, int length, int step) {
  int localID = get_local_id(0);
  int groupID = get_group_id(0);
  int groupSize = get_local_size(0);
  int startOffset = groupID * (groupSize << 1) * step;

  if (groupID) {
    int value = globalArray[hook(0, startOffset)];
    int posi1 = startOffset + localID * step;
    int posi2 = posi1 + groupSize * step;
    if (posi1 < length && localID)
      globalArray[hook(0, posi1)] += value;
    if (posi2 < length)
      globalArray[hook(0, posi2)] += value;
  }
}