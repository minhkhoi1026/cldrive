//{"matrixA":0,"matrixB":1,"matrixC":2,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmmKernel(global double4* matrixA, global double4* matrixB, global double4* matrixC, unsigned int widthA, unsigned int widthB) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  double4 sum0 = (double4)(0);
  double4 sum1 = (double4)(0);
  double4 sum2 = (double4)(0);
  double4 sum3 = (double4)(0);

  widthB /= 4;

  for (int i = 0; i < widthA; i = i + 4) {
    double4 tempA0 = matrixA[hook(0, i / 4 + (pos.y << 2) * (widthA / 4))];
    double4 tempA1 = matrixA[hook(0, i / 4 + ((pos.y << 2) + 1) * (widthA / 4))];
    double4 tempA2 = matrixA[hook(0, i / 4 + ((pos.y << 2) + 2) * (widthA / 4))];
    double4 tempA3 = matrixA[hook(0, i / 4 + ((pos.y << 2) + 3) * (widthA / 4))];

    double4 tempB0 = matrixB[hook(1, pos.x + i * widthB)];
    double4 tempB1 = matrixB[hook(1, pos.x + (i + 1) * widthB)];
    double4 tempB2 = matrixB[hook(1, pos.x + (i + 2) * widthB)];
    double4 tempB3 = matrixB[hook(1, pos.x + (i + 3) * widthB)];

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
  matrixC[hook(2, pos.x + ((pos.y << 2) + 0) * widthB)] = sum0;
  matrixC[hook(2, pos.x + ((pos.y << 2) + 1) * widthB)] = sum1;
  matrixC[hook(2, pos.x + ((pos.y << 2) + 2) * widthB)] = sum2;
  matrixC[hook(2, pos.x + ((pos.y << 2) + 3) * widthB)] = sum3;
}