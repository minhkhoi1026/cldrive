//{"globalArray":0,"length":1,"localArray":3,"step":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scan(global int* globalArray, int length, int step, local int* localArray) {
  int localID = get_local_id(0);
  int groupID = get_group_id(0);
  int groupSize = get_local_size(0);
  int startOffset = (groupSize << 1) * groupID * step;

  int posi1 = startOffset + localID * step;
  int posi2 = posi1 + groupSize * step;

  localArray[hook(3, ((localID) + ((localID) >> (4))))] = posi1 < length ? globalArray[hook(0, posi1)] : 0;
  localArray[hook(3, ((localID + groupSize) + ((localID + groupSize) >> (4))))] = posi2 < length ? globalArray[hook(0, posi2)] : 0;

  for (int stride = 1, d = groupSize; stride <= groupSize; stride <<= 1, d >>= 1) {
    barrier(0x01);

    if (localID < d) {
      posi1 = stride * ((localID << 1) + 1) - 1;
      posi2 = posi1 + stride;
      localArray[hook(3, ((posi2) + ((posi2) >> (4))))] += localArray[hook(3, ((posi1) + ((posi1) >> (4))))];
    }
  }

  for (int stride = groupSize, d = 1; stride >= 1; stride >>= 1, d <<= 1) {
    barrier(0x01);

    if (localID < d) {
      posi1 = stride * ((localID << 1) + 1) - 1;
      posi2 = ((posi1 + stride) + ((posi1 + stride) >> (4)));
      posi1 = ((posi1) + ((posi1) >> (4)));

      int t = localArray[hook(3, posi1)];
      localArray[hook(3, posi1)] = localArray[hook(3, posi2)];
      localArray[hook(3, posi2)] = localArray[hook(3, posi2)] * !!localID + t;
    }
  }

  barrier(0x01);

  posi1 = startOffset + localID * step;
  posi2 = posi1 + groupSize * step;

  if (posi1 < length)
    globalArray[hook(0, posi1)] = localArray[hook(3, ((localID) + ((localID) >> (4))))];
  if (posi2 < length)
    globalArray[hook(0, posi2)] = localArray[hook(3, ((localID + groupSize) + ((localID + groupSize) >> (4))))];
}