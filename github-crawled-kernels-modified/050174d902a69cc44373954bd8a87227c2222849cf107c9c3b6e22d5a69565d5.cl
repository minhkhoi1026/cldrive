//{"matrixA":0,"matrixB":1,"matrixC":2,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 4 | 0x10;
kernel void mmmKernel2(read_only image2d_t matrixA, read_only image2d_t matrixB, write_only image2d_t matrixC, unsigned int widthA, unsigned int widthB) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  float4 sum0 = (float4)(0);
  float4 sum1 = (float4)(0);
  float4 sum2 = (float4)(0);
  float4 sum3 = (float4)(0);
  float4 sum4 = (float4)(0);
  float4 sum5 = (float4)(0);
  float4 sum6 = (float4)(0);
  float4 sum7 = (float4)(0);

  widthB = widthB >> 2;

  for (int i = 0; i < widthA; i = i + 4) {
    float4 tempA0 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, pos.y << 3));
    float4 tempA1 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, (pos.y << 3) + 1));
    float4 tempA2 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, (pos.y << 3) + 2));
    float4 tempA3 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, (pos.y << 3) + 3));
    float4 tempA4 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, (pos.y << 3) + 4));
    float4 tempA5 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, (pos.y << 3) + 5));
    float4 tempA6 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, (pos.y << 3) + 6));
    float4 tempA7 = read_imagef(matrixA, imageSampler, (int2)(i >> 2, (pos.y << 3) + 7));

    float4 tempB0 = read_imagef(matrixB, imageSampler, (int2)(pos.x, i));
    float4 tempB1 = read_imagef(matrixB, imageSampler, (int2)(pos.x, i + 1));
    float4 tempB2 = read_imagef(matrixB, imageSampler, (int2)(pos.x, i + 2));
    float4 tempB3 = read_imagef(matrixB, imageSampler, (int2)(pos.x, i + 3));

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

    sum4.x += tempA4.x * tempB0.x + tempA4.y * tempB1.x + tempA4.z * tempB2.x + tempA4.w * tempB3.x;
    sum4.y += tempA4.x * tempB0.y + tempA4.y * tempB1.y + tempA4.z * tempB2.y + tempA4.w * tempB3.y;
    sum4.z += tempA4.x * tempB0.z + tempA4.y * tempB1.z + tempA4.z * tempB2.z + tempA4.w * tempB3.z;
    sum4.w += tempA4.x * tempB0.w + tempA4.y * tempB1.w + tempA4.z * tempB2.w + tempA4.w * tempB3.w;

    sum5.x += tempA5.x * tempB0.x + tempA5.y * tempB1.x + tempA5.z * tempB2.x + tempA5.w * tempB3.x;
    sum5.y += tempA5.x * tempB0.y + tempA5.y * tempB1.y + tempA5.z * tempB2.y + tempA5.w * tempB3.y;
    sum5.z += tempA5.x * tempB0.z + tempA5.y * tempB1.z + tempA5.z * tempB2.z + tempA5.w * tempB3.z;
    sum5.w += tempA5.x * tempB0.w + tempA5.y * tempB1.w + tempA5.z * tempB2.w + tempA5.w * tempB3.w;

    sum6.x += tempA6.x * tempB0.x + tempA6.y * tempB1.x + tempA6.z * tempB2.x + tempA6.w * tempB3.x;
    sum6.y += tempA6.x * tempB0.y + tempA6.y * tempB1.y + tempA6.z * tempB2.y + tempA6.w * tempB3.y;
    sum6.z += tempA6.x * tempB0.z + tempA6.y * tempB1.z + tempA6.z * tempB2.z + tempA6.w * tempB3.z;
    sum6.w += tempA6.x * tempB0.w + tempA6.y * tempB1.w + tempA6.z * tempB2.w + tempA6.w * tempB3.w;

    sum7.x += tempA7.x * tempB0.x + tempA7.y * tempB1.x + tempA7.z * tempB2.x + tempA7.w * tempB3.x;
    sum7.y += tempA7.x * tempB0.y + tempA7.y * tempB1.y + tempA7.z * tempB2.y + tempA7.w * tempB3.y;
    sum7.z += tempA7.x * tempB0.z + tempA7.y * tempB1.z + tempA7.z * tempB2.z + tempA7.w * tempB3.z;
    sum7.w += tempA7.x * tempB0.w + tempA7.y * tempB1.w + tempA7.z * tempB2.w + tempA7.w * tempB3.w;
  }
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8), sum0);
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8 + 1), sum1);
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8 + 2), sum2);
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8 + 3), sum3);
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8 + 4), sum4);
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8 + 5), sum5);
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8 + 6), sum6);
  write_imagef(matrixC, (int2)(pos.x, pos.y * 8 + 7), sum7);
}