//{"matrixA":0,"matrixB":1,"matrixSize":3,"matrixWidth":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication_int_O2(global int4* matrixA, global int* matrixB, global int* output, int matrixSize, int matrixWidth) {
  int y = get_global_id(0);
  int x = get_global_id(1);
  int widthA = matrixSize / 4;

  int4 sum1 = (int4){0, 0, 0, 0};
  int4 sum2 = (int4){0, 0, 0, 0};
  int4 sum3 = (int4){0, 0, 0, 0};
  int4 sum4 = (int4){0, 0, 0, 0};
  int4 sum5 = (int4){0, 0, 0, 0};
  int4 sum6 = (int4){0, 0, 0, 0};
  int4 sum7 = (int4){0, 0, 0, 0};
  int4 sum8 = (int4){0, 0, 0, 0};
  int4 sum9 = (int4){0, 0, 0, 0};
  int4 sum10 = (int4){0, 0, 0, 0};
  int4 sum11 = (int4){0, 0, 0, 0};
  int4 sum12 = (int4){0, 0, 0, 0};
  int4 sum13 = (int4){0, 0, 0, 0};
  int4 sum14 = (int4){0, 0, 0, 0};
  int4 sum15 = (int4){0, 0, 0, 0};
  int4 sum16 = (int4){0, 0, 0, 0};

  int idxA = x * 4 * widthA;
  int idxO;

  for (int i = 0; i < widthA; i++) {
    int idxB = i * 4 * matrixWidth + y * 4;
    int4 tmpA1 = matrixA[hook(0, idxA + i)];
    int4 tmpA2 = matrixA[hook(0, idxA + 1 * widthA + i)];
    int4 tmpA3 = matrixA[hook(0, idxA + 2 * widthA + i)];
    int4 tmpA4 = matrixA[hook(0, idxA + 3 * widthA + i)];
    int4 tmpB1 = (int4){matrixB[hook(1, idxB)], matrixB[hook(1, idxB + 1 * matrixSize)], matrixB[hook(1, idxB + 2 * matrixSize)], matrixB[hook(1, idxB + 3 * matrixSize)]};
    int4 tmpB2 = (int4){matrixB[hook(1, idxB + 1)], matrixB[hook(1, idxB + 1 * matrixSize + 1)], matrixB[hook(1, idxB + 2 * matrixSize + 1)], matrixB[hook(1, idxB + 3 * matrixSize + 1)]};
    int4 tmpB3 = (int4){matrixB[hook(1, idxB + 2)], matrixB[hook(1, idxB + 1 * matrixSize + 2)], matrixB[hook(1, idxB + 2 * matrixSize + 2)], matrixB[hook(1, idxB + 3 * matrixSize + 2)]};
    int4 tmpB4 = (int4){matrixB[hook(1, idxB + 3)], matrixB[hook(1, idxB + 1 * matrixSize + 3)], matrixB[hook(1, idxB + 2 * matrixSize + 3)], matrixB[hook(1, idxB + 3 * matrixSize + 3)]};

    sum1 += tmpA1 * tmpB1;
    sum2 += tmpA1 * tmpB2;
    sum3 += tmpA1 * tmpB3;
    sum4 += tmpA1 * tmpB4;
    sum5 += tmpA2 * tmpB1;
    sum6 += tmpA2 * tmpB2;
    sum7 += tmpA2 * tmpB3;
    sum8 += tmpA2 * tmpB4;
    sum9 += tmpA3 * tmpB1;
    sum10 += tmpA3 * tmpB2;
    sum11 += tmpA3 * tmpB3;
    sum12 += tmpA3 * tmpB4;
    sum13 += tmpA4 * tmpB1;
    sum14 += tmpA4 * tmpB2;
    sum15 += tmpA4 * tmpB3;
    sum16 += tmpA4 * tmpB4;
  }
  idxO = x * 4 * matrixWidth + y * 4;
  output[hook(2, idxO)] = sum1.x + sum1.y + sum1.z + sum1.w;
  output[hook(2, idxO + 1)] = sum2.x + sum2.y + sum2.z + sum2.w;
  output[hook(2, idxO + 2)] = sum3.x + sum3.y + sum3.z + sum3.w;
  output[hook(2, idxO + 3)] = sum4.x + sum4.y + sum4.z + sum4.w;
  idxO += matrixWidth;
  output[hook(2, idxO)] = sum5.x + sum5.y + sum5.z + sum5.w;
  output[hook(2, idxO + 1)] = sum6.x + sum6.y + sum6.z + sum6.w;
  output[hook(2, idxO + 2)] = sum7.x + sum7.y + sum7.z + sum7.w;
  output[hook(2, idxO + 3)] = sum8.x + sum8.y + sum8.z + sum8.w;
  idxO += matrixWidth;
  output[hook(2, idxO)] = sum9.x + sum9.y + sum9.z + sum9.w;
  output[hook(2, idxO + 1)] = sum10.x + sum10.y + sum10.z + sum10.w;
  output[hook(2, idxO + 2)] = sum11.x + sum11.y + sum11.z + sum11.w;
  output[hook(2, idxO + 3)] = sum12.x + sum12.y + sum12.z + sum12.w;
  idxO += matrixWidth;
  output[hook(2, idxO)] = sum13.x + sum13.y + sum13.z + sum13.w;
  output[hook(2, idxO + 1)] = sum14.x + sum14.y + sum14.z + sum14.w;
  output[hook(2, idxO + 2)] = sum15.x + sum15.y + sum15.z + sum15.w;
  output[hook(2, idxO + 3)] = sum16.x + sum16.y + sum16.z + sum16.w;
}