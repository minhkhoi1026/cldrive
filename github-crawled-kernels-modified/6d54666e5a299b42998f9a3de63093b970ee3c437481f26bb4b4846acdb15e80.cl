//{"matrixA":0,"matrixB":1,"matrixC":2,"widthA":3,"widthB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 4 | 0x10;
float4 mat_mult_mini(float4 a, float4 b0, float4 b1, float4 b2, float4 b3, float4 c) {
  float4 tmp = mad((float4)a.x, b0, c);
  tmp = mad((float4)a.y, b1, tmp);
  tmp = mad((float4)a.z, b2, tmp);
  tmp = mad((float4)a.w, b3, tmp);
  return tmp;
}
float4 mat_mult_pre(float4 a, float4 b0, float4 b1, float4 b2, float4 b3) {
  float4 tmp = (float4)a.x * b0;
  tmp = mad((float4)a.y, b1, tmp);
  tmp = mad((float4)a.z, b2, tmp);
  tmp = mad((float4)a.w, b3, tmp);
  return tmp;
}

kernel void mmmKernel3(read_only image2d_t matrixA, read_only image2d_t matrixB, write_only image2d_t matrixC, unsigned int widthA, unsigned int widthB) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  float4 sum0;
  float4 sum1;
  float4 sum2;
  float4 sum3;
  float4 sum4;
  float4 sum5;
  float4 sum6;
  float4 sum7;

  widthB = widthB >> 2;

  int8 offsety = (int8)(0, 1, 2, 3, 4, 5, 6, 7);
  int4 offsetx = (int4)(0, 1, 2, 3);
  int xpos = pos.x;
  int ypos = pos.y;
  int8 ybs = (int8)(ypos << 3) + offsety;
  int j = 0;
  int ib4 = 0;
  int4 ioff = offsetx;

  float4 tempA0 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s0));
  float4 tempA1 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s1));
  float4 tempA2 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s2));
  float4 tempA3 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s3));
  float4 tempA4 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s4));
  float4 tempA5 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s5));
  float4 tempA6 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s6));
  float4 tempA7 = read_imagef(matrixA, imageSampler, (int2)(0, ybs.s7));
  float4 tempB0 = read_imagef(matrixB, imageSampler, (int2)(pos.x, 0));
  float4 tempB1 = read_imagef(matrixB, imageSampler, (int2)(pos.x, 1));
  float4 tempB2 = read_imagef(matrixB, imageSampler, (int2)(pos.x, 2));
  float4 tempB3 = read_imagef(matrixB, imageSampler, (int2)(pos.x, 3));
  sum0 = mat_mult_pre(tempA0, tempB0, tempB1, tempB2, tempB3);
  sum1 = mat_mult_pre(tempA1, tempB0, tempB1, tempB2, tempB3);
  sum2 = mat_mult_pre(tempA2, tempB0, tempB1, tempB2, tempB3);
  sum3 = mat_mult_pre(tempA3, tempB0, tempB1, tempB2, tempB3);
  sum4 = mat_mult_pre(tempA4, tempB0, tempB1, tempB2, tempB3);
  sum5 = mat_mult_pre(tempA5, tempB0, tempB1, tempB2, tempB3);
  sum6 = mat_mult_pre(tempA6, tempB0, tempB1, tempB2, tempB3);
  sum7 = mat_mult_pre(tempA7, tempB0, tempB1, tempB2, tempB3);
  for (int i = 4; i < widthA; i = i + 4) {
    int ib4 = i >> 2;
    int4 ioff = (int4)(i) + offsetx;
    tempA0 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s0));
    tempA1 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s1));
    tempA2 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s2));
    tempA3 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s3));
    tempB0 = read_imagef(matrixB, imageSampler, (int2)(pos.x, ioff.s0));
    tempB1 = read_imagef(matrixB, imageSampler, (int2)(pos.x, ioff.s1));
    tempB2 = read_imagef(matrixB, imageSampler, (int2)(pos.x, ioff.s2));
    tempB3 = read_imagef(matrixB, imageSampler, (int2)(pos.x, ioff.s3));
    tempA4 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s4));
    tempA5 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s5));
    tempA6 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s6));
    tempA7 = read_imagef(matrixA, imageSampler, (int2)(ib4, ybs.s7));
    sum0 = mat_mult_mini(tempA0, tempB0, tempB1, tempB2, tempB3, sum0);
    sum1 = mat_mult_mini(tempA1, tempB0, tempB1, tempB2, tempB3, sum1);
    sum2 = mat_mult_mini(tempA2, tempB0, tempB1, tempB2, tempB3, sum2);
    sum3 = mat_mult_mini(tempA3, tempB0, tempB1, tempB2, tempB3, sum3);
    sum4 = mat_mult_mini(tempA4, tempB0, tempB1, tempB2, tempB3, sum4);
    sum5 = mat_mult_mini(tempA5, tempB0, tempB1, tempB2, tempB3, sum5);
    sum6 = mat_mult_mini(tempA6, tempB0, tempB1, tempB2, tempB3, sum6);
    sum7 = mat_mult_mini(tempA7, tempB0, tempB1, tempB2, tempB3, sum7);
  }
  ypos = pos.y * 8;
  int8 ypos8 = (int8)(ypos) + offsety;
  write_imagef(matrixC, (int2)(pos.x, ypos8.s0), sum0);
  write_imagef(matrixC, (int2)(pos.x, ypos8.s1), sum1);
  write_imagef(matrixC, (int2)(pos.x, ypos8.s2), sum2);
  write_imagef(matrixC, (int2)(pos.x, ypos8.s3), sum3);
  write_imagef(matrixC, (int2)(pos.x, ypos8.s4), sum4);
  write_imagef(matrixC, (int2)(pos.x, ypos8.s5), sum5);
  write_imagef(matrixC, (int2)(pos.x, ypos8.s6), sum6);
  write_imagef(matrixC, (int2)(pos.x, ypos8.s7), sum7);
}