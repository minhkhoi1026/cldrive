//{"M":2,"irowIdx":1,"nNZ":3,"orowIdx":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void csrReduce_kernel(global int* orowIdx, global const int* irowIdx, const int M, const int nNZ) {
  int id = get_global_id(0);

  if (id >= nNZ)
    return;

  int iRId = irowIdx[hook(1, id)];
  int iRId1 = 0;
  if (id > 0)
    iRId1 = irowIdx[hook(1, id - 1)];

  if (id == 0) {
    orowIdx[hook(0, id)] = 0;
    orowIdx[hook(0, M)] = nNZ;
  } else if (iRId1 != iRId) {
    for (int i = iRId1 + 1; i <= iRId; i++)
      orowIdx[hook(0, i)] = id;
  }

  if (id < M) {
    if (id > irowIdx[hook(1, nNZ - 1)] && orowIdx[hook(0, id)] == 0) {
      orowIdx[hook(0, id)] = nNZ;
    }
  }
}