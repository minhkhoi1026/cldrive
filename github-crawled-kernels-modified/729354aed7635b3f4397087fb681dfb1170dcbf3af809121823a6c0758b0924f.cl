//{"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_1(global int4* matrixA, global int* matrixB, global int* output, int matrixSize, int matrixWidth) {
  int4 sum, tmpA, tmpB;
  int y = get_global_id(0);
  int x = get_global_id(1);

  sum = (int4){0, 0, 0, 0};
  for (int i = 0; i < matrixWidth / 4; i++) {
    tmpA = matrixA[hook(0, x * matrixWidth / 4 + i)];
    tmpB = (int4){matrixB[hook(1, i * 4 * matrixSize + y)], matrixB[hook(1, (i * 4 + 1) * matrixSize + y)], matrixB[hook(1, (i * 4 + 2) * matrixSize + y)], matrixB[hook(1, (i * 4 + 3) * matrixSize + y)]};
    sum += tmpA + tmpB;
  }
  output[hook(2, x * matrixSize + y)] = sum.x + sum.y + sum.z + sum.w;
}