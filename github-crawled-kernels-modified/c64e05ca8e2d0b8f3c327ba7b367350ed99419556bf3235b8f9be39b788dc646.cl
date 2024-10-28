//{"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_int_O3(global int4* matrixA, global int4* matrixB, global int4* output, int matrixSize, int matrixWidth) {
  int y = get_global_id(0);
  int x = get_global_id(1);
  int widthA = matrixSize / 4;
  int widthB = matrixWidth / 4;

  int4 sum0 = (int4){0, 0, 0, 0};
  int4 sum1 = (int4){0, 0, 0, 0};
  int4 sum2 = (int4){0, 0, 0, 0};
  int4 sum3 = (int4){0, 0, 0, 0};

  int idxA = x * 4 * widthA;

  for (int i = 0; i < widthA; i++) {
    int4 tempA0 = matrixA[hook(0, idxA + i)];
    int4 tempA1 = matrixA[hook(0, idxA + 1 * widthA + i)];
    int4 tempA2 = matrixA[hook(0, idxA + 2 * widthA + i)];
    int4 tempA3 = matrixA[hook(0, idxA + 3 * widthA + i)];
    int4 tempB0 = matrixB[hook(1, i * 4 * widthB + y)];
    int4 tempB1 = matrixB[hook(1, (i * 4 + 1) * widthB + y)];
    int4 tempB2 = matrixB[hook(1, (i * 4 + 2) * widthB + y)];
    int4 tempB3 = matrixB[hook(1, (i * 4 + 3) * widthB + y)];

    sum0.x += tempA0.x * tempB0.x + tempA0.y * tempB1.x + tempA0.z * tempB2.x + tempA0.w * tempB3.x;
    sum0.y += tempA0.x * tempB0.y + tempA0.y * tempB1.y + tempA0.z * tempB2.y + tempA0.w * tempB3.y;
    sum0.z += tempA0.x * tempB0.z + tempA0.y * tempB1.z + tempA0.z * tempB2.z + tempA0.w * tempB3.z;
    sum0.w += tempA0.x * tempB0.w + tempA0.y * tempB1.w + tempA0.z * tempB2.w + tempA0.w * tempB3.w;

    sum1.x += tempA1.x * tempB0.x + tempA1.y * tempB1.x + tempA1.z * tempB2.x + tempA1.w * tempB3.x;
    sum1.y += tempA1.x * tempB0.y + tempA1.y * tempB1.y + tempA1.z * tempB2.y + tempA1.w * tempB3.y;
    sum1.z += tempA1.x * tempB0.z + tempA1.y * tempB1.z + tempA1.z * tempB2.z + tempA1.w * tempB3.z;
    sum1.w += tempA1.x * tempB0.w + tempA1.y * tempB1.w + tempA1.z * tempB2.w + tempA1.w * tempB3.w;

    sum2.x += tempA2.x * tempB0.x + tempA2.y * tempB1.x + tempA2.z * tempB2.x + tempA2.w * tempB3.x;
    sum2.y += tempA2.x * tempB0.y + tempA2.y * tempB1.y + tempA2.z * tempB2.y + tempA2.w * tempB3.y;
    sum2.z += tempA2.x * tempB0.z + tempA2.y * tempB1.z + tempA2.z * tempB2.z + tempA2.w * tempB3.z;
    sum2.w += tempA2.x * tempB0.w + tempA2.y * tempB1.w + tempA2.z * tempB2.w + tempA2.w * tempB3.w;

    sum3.x += tempA3.x * tempB0.x + tempA3.y * tempB1.x + tempA3.z * tempB2.x + tempA3.w * tempB3.x;
    sum3.y += tempA3.x * tempB0.y + tempA3.y * tempB1.y + tempA3.z * tempB2.y + tempA3.w * tempB3.y;
    sum3.z += tempA3.x * tempB0.z + tempA3.y * tempB1.z + tempA3.z * tempB2.z + tempA3.w * tempB3.z;
    sum3.w += tempA3.x * tempB0.w + tempA3.y * tempB1.w + tempA3.z * tempB2.w + tempA3.w * tempB3.w;
  }
  output[hook(2, x * 4 * widthB + y)] = sum0;
  output[hook(2, (x * 4 + 1) * widthB + y)] = sum1;
  output[hook(2, (x * 4 + 2) * widthB + y)] = sum2;
  output[hook(2, (x * 4 + 3) * widthB + y)] = sum3;
}