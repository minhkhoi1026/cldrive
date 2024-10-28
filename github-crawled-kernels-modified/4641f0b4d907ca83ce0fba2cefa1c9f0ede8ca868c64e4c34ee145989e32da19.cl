//{"A":0,"C":1,"dimsA":2,"tileOfA":3,"tileOfAT":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmult4(global int* A, global int* C, private int2 dimsA, local int* tileOfA, local int* tileOfAT) {
  unsigned int loops;

  unsigned int gRow = get_global_id(1);
  unsigned int gCol = get_global_id(0);

  unsigned int lRow = get_local_id(1);
  unsigned int lCol = get_local_id(0);

  unsigned int localCols = min((unsigned int)get_local_size(0), (unsigned int)dimsA.y);
  loops = (dimsA.x % localCols == 0) ? (dimsA.x / localCols) : (dimsA.x / localCols + 1);
  for (unsigned int i = 0; i < loops; i++) {
    unsigned int tileCol = i * localCols + lCol;
    if (tileCol < dimsA.x)
      tileOfA[hook(3, lRow * dimsA.x + tileCol)] = A[hook(0, gRow * dimsA.x + tileCol)];
  }

  unsigned int localRows = min((unsigned int)get_local_size(1), (unsigned int)dimsA.y);
  loops = (dimsA.x % localRows == 0) ? (dimsA.x / localRows) : (dimsA.x / localRows + 1);
  for (unsigned int i = 0; i < loops; i++) {
    unsigned int stripSize = dimsA.x * localCols;
    unsigned int globalPos = stripSize * get_group_id(0);
    unsigned int localPos = i * localCols * localRows;
    unsigned int localIndex = lRow * localCols + lCol;
    unsigned int globalIndex = globalPos + localPos + localIndex;
    if (globalIndex < stripSize * (get_group_id(0) + 1))
      tileOfAT[hook(4, localPos + localIndex)] = A[hook(0, globalIndex)];
  }

  barrier(0x01);

  if ((gRow < dimsA.y) && (gCol < dimsA.y)) {
    int sum = 0;
    for (unsigned int i = 0; i < dimsA.x; i++) {
      sum += tileOfA[hook(3, lRow * dimsA.x + i)] * tileOfAT[hook(4, lCol * dimsA.x + i)];
    }
    C[hook(1, gRow * dimsA.y + gCol)] = sum;
  }
}