//{"globalData":0,"localData":1,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bankconf(global int* globalData, local int* localData, private unsigned int stride) {
  unsigned int gRow = get_global_id(1);
  unsigned int gCol = get_global_id(0);
  unsigned int lRow = get_local_id(1);
  unsigned int lCol = get_local_id(0);
  unsigned int gTotCols = get_global_size(0);
  unsigned int lTotCols = get_local_size(0);
  unsigned int lTotElems = get_local_size(0) * get_local_size(1);
  unsigned int gIndex = gRow * gTotCols + gCol;
  unsigned int lIndex = lRow * lTotCols + lCol;

  localData[hook(1, lIndex)] = globalData[hook(0, gIndex)];

  barrier(0x01);

  int sum = 0;

  for (unsigned int i = 0; i < lTotCols; i++) {
    unsigned int idx = lIndex * stride + i;

    if (idx >= lTotElems)
      idx = idx - (idx / lTotElems) * lTotElems;

    sum += localData[hook(1, idx)];
  }

  globalData[hook(0, gIndex)] = sum;
}