//{"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_double(global double* matrixA, global double* matrixB, global double* output, int matrixSize, int matrixWidth) {
  double sum;
  int y = get_global_id(0);
  int x = get_global_id(1);

  sum = 0.0;
  for (int i = 0; i < matrixWidth; i++) {
    sum += matrixA[hook(0, x * matrixWidth + i)] * matrixB[hook(1, i * matrixSize + y)];
  }
  output[hook(2, x * matrixSize + y)] = sum;
}