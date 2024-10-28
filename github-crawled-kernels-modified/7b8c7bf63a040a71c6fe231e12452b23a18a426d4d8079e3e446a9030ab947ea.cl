//{"a":0,"arrayA":3,"arrayB":4,"arrayC":5,"arrayD":6,"e":1,"length":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) krnl_vadd(global int* a, global int* e, const int length) {
  int arrayA[256];
  int arrayB[256];
  int arrayC[256];
  int arrayD[256];
  for (int i = 0; i < length; i += 256) {
    int size = 256;
    if (i + size > length)
      size = length - i;

    __attribute__((xcl_pipeline_loop)) readA : for (int j = 0; j < 4 * size; j++) {
      int tmpValue = a[hook(0, i + j)];
      switch (j % 4) {
        case 0:
          arrayA[hook(3, j / 4)] = tmpValue;
          break;
        case 1:
          arrayB[hook(4, j / 4)] = tmpValue;
          break;
        case 2:
          arrayC[hook(5, j / 4)] = tmpValue;
          break;
        case 3:
          arrayD[hook(6, j / 4)] = tmpValue;
          break;
      }
    }
  vadd_writeC:
    for (int j = 0; j < size; j++)
      e[hook(1, j)] = arrayA[hook(3, j)] + arrayB[hook(4, j)] + arrayC[hook(5, j)] + arrayD[hook(6, j)];
  }
  return;
}