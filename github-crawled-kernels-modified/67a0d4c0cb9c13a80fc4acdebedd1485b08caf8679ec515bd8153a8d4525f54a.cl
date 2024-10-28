//{"A":0,"B":1,"C":2,"dimsA":3,"dimsB":4,"tileOfA":5,"tileOfB":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmult2(global int* A, global int* B, global int* C, private int2 dimsA, private int2 dimsB, local int* tileOfA, local int* tileOfB) {
  unsigned int loops;

  unsigned int gCol = get_global_id(0);
  unsigned int gRow = get_global_id(1);

  unsigned int lCol = get_local_id(0);
  unsigned int lRow = get_local_id(1);

  unsigned int localCols = min((unsigned int)get_local_size(0), (unsigned int)dimsB.x);
  loops = (dimsA.x % localCols == 0) ? (dimsA.x / localCols) : (dimsA.x / localCols + 1);
  for (unsigned int i = 0; i < loops; i++) {
    unsigned int tileCol = i * localCols + lCol;
    if (tileCol < dimsA.x)
      tileOfA[hook(5, lRow * dimsA.x + tileCol)] = A[hook(0, gRow * dimsA.x + tileCol)];
  }

  unsigned int localRows = min((unsigned int)get_local_size(1), (unsigned int)dimsB.y);
  loops = (dimsB.y % localRows == 0) ? (dimsB.y / localRows) : (dimsB.y / localRows + 1);
  for (unsigned int i = 0; i < loops; i++) {
    unsigned int localPos = i * localCols * localRows + lRow * localCols + lCol;
    unsigned int globalRow = i * localRows + lRow;
    unsigned int globalCol = get_group_id(0) * localCols + lCol;
    if ((globalRow < dimsB.y) && (globalCol < dimsB.x))
      tileOfB[hook(6, localPos)] = B[hook(1, globalRow * dimsB.x + globalCol)];
  }

  barrier(0x01);

  if ((gRow < dimsA.y) && (gCol < dimsB.x)) {
    int sum = 0;
    for (unsigned int i = 0; i < dimsA.x; i++) {
      sum += tileOfA[hook(5, lRow * dimsA.x + i)] * tileOfB[hook(6, i * localCols + lCol)];
    }
    C[hook(2, gRow * dimsB.x + gCol)] = sum;
  }
}