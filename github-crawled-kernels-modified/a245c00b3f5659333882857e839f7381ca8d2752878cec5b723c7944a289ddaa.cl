//{"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_2(global int* matrixA, global int* matrixB, global int* output, int matrixSize, int matrixWidth) {
  int sum, tmpA, tmpB;
  int y = get_global_id(0);
  int x = get_global_id(1);

  sum = 0;
  for (int i = 0; i < matrixWidth; i++) {
    tmpA = matrixA[hook(0, x * matrixWidth + i)];
    tmpB = matrixB[hook(1, i * matrixSize + y)];
    sum += tmpA + tmpB;
    sum += tmpA * tmpB;
  }
  output[hook(2, x * matrixSize + y)] = sum;
}