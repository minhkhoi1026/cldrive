//{"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_int_O1(global int4* matrixA, global int* matrixB, global int* output, int matrixSize, int matrixWidth) {
  int4 sum1, sum2, sum3, sum4;
  int y = get_global_id(0);
  int x = get_global_id(1);

  sum1 = (int4){0, 0, 0, 0};
  sum2 = (int4){0, 0, 0, 0};
  sum3 = (int4){0, 0, 0, 0};
  sum4 = (int4){0, 0, 0, 0};
  for (int i = 0; i < matrixWidth / 4; i++) {
    int4 tmpA = matrixA[hook(0, x * matrixWidth / 4 + i)];
    int idx = i * 4 * matrixSize + y * 4;
    sum1 += tmpA * (int4){matrixB[hook(1, idx)], matrixB[hook(1, idx + 1 * matrixSize)], matrixB[hook(1, idx + 2 * matrixSize)], matrixB[hook(1, idx + 3 * matrixSize)]};
    sum2 += tmpA * (int4){matrixB[hook(1, idx + 1)], matrixB[hook(1, idx + 1 * matrixSize + 1)], matrixB[hook(1, idx + 2 * matrixSize + 1)], matrixB[hook(1, idx + 3 * matrixSize + 1)]};
    sum3 += tmpA * (int4){matrixB[hook(1, idx + 2)], matrixB[hook(1, idx + 1 * matrixSize + 2)], matrixB[hook(1, idx + 2 * matrixSize + 2)], matrixB[hook(1, idx + 3 * matrixSize + 2)]};
    sum4 += tmpA * (int4){matrixB[hook(1, idx + 3)], matrixB[hook(1, idx + 1 * matrixSize + 3)], matrixB[hook(1, idx + 2 * matrixSize + 3)], matrixB[hook(1, idx + 3 * matrixSize + 3)]};
  }
  output[hook(2, x * matrixSize + y * 4)] = sum1.x + sum1.y + sum1.z + sum1.w;
  output[hook(2, x * matrixSize + y * 4 + 1)] = sum2.x + sum2.y + sum2.z + sum2.w;
  output[hook(2, x * matrixSize + y * 4 + 2)] = sum3.x + sum3.y + sum3.z + sum3.w;
  output[hook(2, x * matrixSize + y * 4 + 3)] = sum4.x + sum4.y + sum4.z + sum4.w;
}