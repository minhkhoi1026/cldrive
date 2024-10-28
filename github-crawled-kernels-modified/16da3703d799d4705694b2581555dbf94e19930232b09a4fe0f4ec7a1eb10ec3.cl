//{"blockA":4,"matrixA":0,"matrixB":1,"matrixC":2,"widthA":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmmKernel_local(global float4* matrixA, global float4* matrixB, global float4* matrixC, int widthA, local float4* blockA) {
  int blockPos = get_local_id(0) + get_local_size(0) * (get_local_id(1) << 2);

  int globalPos = get_global_id(0) + (get_global_id(1) << 2) * get_global_size(0);

  float4 sum0 = (float4)(0);
  float4 sum1 = (float4)(0);
  float4 sum2 = (float4)(0);
  float4 sum3 = (float4)(0);

  int temp = widthA / 4;

  for (int i = 0; i < (temp / get_local_size(0)); i++) {
    int globalPosA = i * get_local_size(0) + get_local_id(0) + (get_global_id(1) << 2) * temp;

    blockA[hook(4, blockPos)] = matrixA[hook(0, globalPosA)];
    blockA[hook(4, blockPos + get_local_size(0))] = matrixA[hook(0, globalPosA + temp)];
    blockA[hook(4, blockPos + 2 * get_local_size(0))] = matrixA[hook(0, globalPosA + 2 * temp)];
    blockA[hook(4, blockPos + 3 * get_local_size(0))] = matrixA[hook(0, globalPosA + 3 * temp)];

    barrier(0x01);

    int globalPosB = get_global_id(0) + ((i * get_local_size(0)) << 2) * get_global_size(0);

    for (int j = 0; j < get_local_size(0) * 4; j = j + 4) {
      float4 tempA0 = blockA[hook(4, (j >> 2) + get_local_id(1) * 4 * get_local_size(0))];
      float4 tempA1 = blockA[hook(4, (j >> 2) + (get_local_id(1) * 4 + 1) * get_local_size(0))];
      float4 tempA2 = blockA[hook(4, (j >> 2) + (get_local_id(1) * 4 + 2) * get_local_size(0))];
      float4 tempA3 = blockA[hook(4, (j >> 2) + (get_local_id(1) * 4 + 3) * get_local_size(0))];

      float4 tempB0 = matrixB[hook(1, globalPosB + j * get_global_size(0))];
      float4 tempB1 = matrixB[hook(1, globalPosB + (j + 1) * get_global_size(0))];
      float4 tempB2 = matrixB[hook(1, globalPosB + (j + 2) * get_global_size(0))];
      float4 tempB3 = matrixB[hook(1, globalPosB + (j + 3) * get_global_size(0))];

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
  }

  matrixC[hook(2, globalPos)] = sum0;
  matrixC[hook(2, globalPos + get_global_size(0))] = sum1;
  matrixC[hook(2, globalPos + 2 * get_global_size(0))] = sum2;
  matrixC[hook(2, globalPos + 3 * get_global_size(0))] = sum3;
}