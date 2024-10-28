//{"Acols":1,"ArowPtr":0,"Bcols":3,"BrowPtr":2,"cooArr_Data":7,"cooArr_X":5,"cooArr_Y":6,"counter":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void spmm_coo_binary_kernel_naive(global const unsigned int* restrict ArowPtr, global const unsigned int* restrict Acols, global const unsigned int* restrict BrowPtr, global const unsigned int* restrict Bcols, global int* counter, global int* cooArr_X, global int* cooArr_Y, global float* cooArr_Data) {
  int currRow = get_global_id(0);
  int currCol = get_global_id(1);

  int ArowCur = ArowPtr[hook(0, currRow)];
  int ArowEnd = ArowPtr[hook(0, currRow + 1)];

  int BrowCur = BrowPtr[hook(2, currCol)];
  int BrowEnd = BrowPtr[hook(2, currCol + 1)];

  int AcurIdx = -1;
  int BcurIdx = -1;

  float localSum = 0;

  while ((ArowCur < ArowEnd) && (BrowCur < BrowEnd)) {
    AcurIdx = Acols[hook(1, ArowCur)];
    BcurIdx = Bcols[hook(3, BrowCur)];

    if (AcurIdx == BcurIdx) {
      localSum += 1;
      ArowCur++;
      BrowCur++;
    } else if (AcurIdx < BcurIdx) {
      ArowCur++;
    } else {
      BrowCur++;
    }
  }

  if (localSum > 0) {
    int localIndex = atomic_add(counter, 1);
    cooArr_X[hook(5, localIndex)] = currRow;
    cooArr_Y[hook(6, localIndex)] = currCol;
    cooArr_Data[hook(7, localIndex)] = localSum;
  }
}