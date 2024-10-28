//{"localA":5,"localB":6,"localSize":7,"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_8(global int* matrixA, global int* matrixB, global int* output, int matrixSize, int matrixWidth, local int* localA, local int* localB, int localSize) {
  int sum, tmpA, tmpB;
  int y = get_global_id(0);
  int x = get_global_id(1);
  int ly = get_local_id(0);
  int lx = get_local_id(1);

  sum = 0;
  for (int i = 0; i < matrixWidth / localSize; i++) {
    localA[hook(5, lx * localSize + ly)] = matrixA[hook(0, x * matrixSize + i * localSize + ly)];
    localB[hook(6, lx * localSize + ly)] = matrixB[hook(1, (i * localSize + lx) * matrixSize + y)];
    barrier(0x01);

    for (int j = 0; j < localSize; j++) {
      tmpA = localA[hook(5, lx * localSize + j)];
      tmpB = localB[hook(6, j * localSize + ly)];
      sum += tmpA + tmpB;
      sum += tmpA - tmpB;
      sum += tmpA * tmpB;
      sum += tmpA / tmpB;
      sum += tmpA < tmpB;
      sum += tmpA > tmpB;
      sum += tmpA & tmpB;
      sum += tmpA | tmpB;
    }
    barrier(0x01);
  }
  output[hook(2, x * matrixSize + y)] = sum;
}