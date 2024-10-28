//{"A":0,"B":1,"C":2,"dimsA":3,"dimsB":4,"tileOfA":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmult1(global int* A, global int* B, global int* C, private int2 dimsA, private int2 dimsB, local int* tileOfA) {
  unsigned int gCol = get_global_id(0);
  unsigned int gRow = get_global_id(1);

  unsigned int lCol = get_local_id(0);
  unsigned int lRow = get_local_id(1);

  unsigned int localCols = min((unsigned int)get_local_size(0), (unsigned int)dimsB.x);
  unsigned int loops = (dimsA.x % localCols == 0) ? (dimsA.x / localCols) : (dimsA.x / localCols + 1);
  for (unsigned int i = 0; i < loops; i++) {
    unsigned int tileCol = i * localCols + lCol;
    if (tileCol < dimsA.x)
      tileOfA[hook(5, lRow * dimsA.x + tileCol)] = A[hook(0, gRow * dimsA.x + tileCol)];
  }

  barrier(0x01);

  if ((gRow < dimsA.y) && (gCol < dimsB.x)) {
    int sum = 0;
    for (unsigned int i = 0; i < dimsA.x; i++) {
      sum += tileOfA[hook(5, lRow * dimsA.x + i)] * B[hook(1, i * dimsB.x + gCol)];
    }
    C[hook(2, gRow * dimsB.x + gCol)] = sum;
  }
}