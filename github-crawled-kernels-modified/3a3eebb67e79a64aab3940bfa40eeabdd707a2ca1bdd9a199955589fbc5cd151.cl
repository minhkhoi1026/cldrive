//{"Acols":1,"ArowPtr":0,"Bcols":3,"BrowPtr":2,"counter":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nnz_calc_kernel(global const unsigned int* restrict ArowPtr, global const unsigned int* restrict Acols, global const unsigned int* restrict BrowPtr, global const unsigned int* restrict Bcols, global int* counter) {
  int currRow = get_global_id(0);
  int currCol = get_global_id(1);

  int ArowCur = ArowPtr[hook(0, currRow)];
  int ArowEnd = ArowPtr[hook(0, currRow + 1)];

  int BrowCur = BrowPtr[hook(2, currCol)];
  int BrowEnd = BrowPtr[hook(2, currCol + 1)];

  int AcurIdx = -1;
  int BcurIdx = -1;

  bool haveNNZ = false;

  while ((ArowCur < ArowEnd) && (BrowCur < BrowEnd)) {
    AcurIdx = Acols[hook(1, ArowCur)];
    BcurIdx = Bcols[hook(3, BrowCur)];

    if (AcurIdx == BcurIdx) {
      haveNNZ = true;
      break;
    } else if (AcurIdx < BcurIdx) {
      ArowCur++;
    } else {
      BrowCur++;
    }
  }

  if (haveNNZ == true) {
    atomic_add(counter, 1);
  }
}