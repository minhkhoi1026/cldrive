//{"bench":7,"float3":8,"mandelbrotImage":0,"maxIterations":5,"posx":1,"posy":2,"stepSizeX":3,"stepSizeY":4,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandelbrot_vector(global uchar4* mandelbrotImage, const float posx, const float posy, const float stepSizeX, const float stepSizeY, const unsigned int maxIterations, const int width, const int bench) {
  int tid = get_global_id(0);

  int i = tid % (width / 4);
  int j = tid / (width / 4);

  int4 veci = {4 * i, 4 * i + 1, 4 * i + 2, 4 * i + 3};
  int4 vecj = {j, j, j, j};

  float4 x0;
  x0.s0 = (float)(posx + stepSizeX * (float)veci.s0);
  x0.s1 = (float)(posx + stepSizeX * (float)veci.s1);
  x0.s2 = (float)(posx + stepSizeX * (float)veci.s2);
  x0.s3 = (float)(posx + stepSizeX * (float)veci.s3);
  float4 y0;
  y0.s0 = (float)(posy + stepSizeY * (float)vecj.s0);
  y0.s1 = (float)(posy + stepSizeY * (float)vecj.s1);
  y0.s2 = (float)(posy + stepSizeY * (float)vecj.s2);
  y0.s3 = (float)(posy + stepSizeY * (float)vecj.s3);

  float4 x = x0;
  float4 y = y0;

  unsigned int iter = 0;
  float4 tmp;
  int4 stay;
  int4 ccount = 0;

  stay.s0 = (x.s0 * x.s0 + y.s0 * y.s0) <= 4.0f;
  stay.s1 = (x.s1 * x.s1 + y.s1 * y.s1) <= 4.0f;
  stay.s2 = (x.s2 * x.s2 + y.s2 * y.s2) <= 4.0f;
  stay.s3 = (x.s3 * x.s3 + y.s3 * y.s3) <= 4.0f;
  float4 savx = x;
  float4 savy = y;
  for (iter = 0; (stay.s0 | stay.s1 | stay.s2 | stay.s3) && (iter < maxIterations); iter += 16) {
    x = savx;
    y = savy;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    tmp = x * x + x0 - y * y;
    y = 2.0f * x * y + y0;
    x = tmp * tmp + x0 - y * y;
    y = 2.0f * tmp * y + y0;

    stay.s0 = (x.s0 * x.s0 + y.s0 * y.s0) <= 4.0f;
    stay.s1 = (x.s1 * x.s1 + y.s1 * y.s1) <= 4.0f;
    stay.s2 = (x.s2 * x.s2 + y.s2 * y.s2) <= 4.0f;
    stay.s3 = (x.s3 * x.s3 + y.s3 * y.s3) <= 4.0f;

    savx.s0 = (stay.s0 ? x.s0 : savx.s0);
    savx.s1 = (stay.s1 ? x.s1 : savx.s1);
    savx.s2 = (stay.s2 ? x.s2 : savx.s2);
    savx.s3 = (stay.s3 ? x.s3 : savx.s3);
    savy.s0 = (stay.s0 ? y.s0 : savy.s0);
    savy.s1 = (stay.s1 ? y.s1 : savy.s1);
    savy.s2 = (stay.s2 ? y.s2 : savy.s2);
    savy.s3 = (stay.s3 ? y.s3 : savy.s3);
    ccount += stay * 16;
  }

  if (!(stay.s0 & stay.s1 & stay.s2 & stay.s3)) {
    iter = 16;
    do {
      x = savx;
      y = savy;
      stay.s0 = ((x.s0 * x.s0 + y.s0 * y.s0) <= 4.0f) && (ccount.s0 < maxIterations);
      stay.s1 = ((x.s1 * x.s1 + y.s1 * y.s1) <= 4.0f) && (ccount.s1 < maxIterations);
      stay.s2 = ((x.s2 * x.s2 + y.s2 * y.s2) <= 4.0f) && (ccount.s2 < maxIterations);
      stay.s3 = ((x.s3 * x.s3 + y.s3 * y.s3) <= 4.0f) && (ccount.s3 < maxIterations);
      tmp = x;
      x = x * x + x0 - y * y;
      y = 2.0f * tmp * y + y0;
      ccount += stay;
      iter--;
      savx.s0 = (stay.s0 ? x.s0 : savx.s0);
      savx.s1 = (stay.s1 ? x.s1 : savx.s1);
      savx.s2 = (stay.s2 ? x.s2 : savx.s2);
      savx.s3 = (stay.s3 ? x.s3 : savx.s3);
      savy.s0 = (stay.s0 ? y.s0 : savy.s0);
      savy.s1 = (stay.s1 ? y.s1 : savy.s1);
      savy.s2 = (stay.s2 ? y.s2 : savy.s2);
      savy.s3 = (stay.s3 ? y.s3 : savy.s3);
    } while ((stay.s0 | stay.s1 | stay.s2 | stay.s3) && iter);
  }
  x = savx;
  y = savy;
  float4 fc = convert_float4(ccount);
  fc.s0 = (float)ccount.s0 + 1 - native_log2(native_log2(x.s0 * x.s0 + y.s0 * y.s0));
  fc.s1 = (float)ccount.s1 + 1 - native_log2(native_log2(x.s1 * x.s1 + y.s1 * y.s1));
  fc.s2 = (float)ccount.s2 + 1 - native_log2(native_log2(x.s2 * x.s2 + y.s2 * y.s2));
  fc.s3 = (float)ccount.s3 + 1 - native_log2(native_log2(x.s3 * x.s3 + y.s3 * y.s3));

  float c = fc.s0 * 2.0f * 3.1416f / 256.0f;
  uchar4 float3[4];
  float3[hook(8, 0)].s0 = ((1.0f + native_cos(c)) * 0.5f) * 255;
  float3[hook(8, 0)].s1 = ((1.0f + native_cos(2.0f * c + 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 0)].s2 = ((1.0f + native_cos(c - 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 0)].s3 = 0xff;
  if (ccount.s0 == maxIterations) {
    float3[hook(8, 0)].s0 = 0;
    float3[hook(8, 0)].s1 = 0;
    float3[hook(8, 0)].s2 = 0;
  }
  if (bench) {
    float3[hook(8, 0)].s0 = ccount.s0 & 0xff;
    float3[hook(8, 0)].s1 = (ccount.s0 & 0xff00) >> 8;
    float3[hook(8, 0)].s2 = (ccount.s0 & 0xff0000) >> 16;
    float3[hook(8, 0)].s3 = (ccount.s0 & 0xff000000) >> 24;
  }
  mandelbrotImage[hook(0, 4 * tid)] = float3[hook(8, 0)];
  c = fc.s1 * 2.0f * 3.1416f / 256.0f;
  float3[hook(8, 1)].s0 = ((1.0f + native_cos(c)) * 0.5f) * 255;
  float3[hook(8, 1)].s1 = ((1.0f + native_cos(2.0f * c + 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 1)].s2 = ((1.0f + native_cos(c - 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 1)].s3 = 0xff;
  if (ccount.s1 == maxIterations) {
    float3[hook(8, 1)].s0 = 0;
    float3[hook(8, 1)].s1 = 0;
    float3[hook(8, 1)].s2 = 0;
  }
  if (bench) {
    float3[hook(8, 1)].s0 = ccount.s1 & 0xff;
    float3[hook(8, 1)].s1 = (ccount.s1 & 0xff00) >> 8;
    float3[hook(8, 1)].s2 = (ccount.s1 & 0xff0000) >> 16;
    float3[hook(8, 1)].s3 = (ccount.s1 & 0xff000000) >> 24;
  }
  mandelbrotImage[hook(0, 4 * tid + 1)] = float3[hook(8, 1)];
  c = fc.s2 * 2.0f * 3.1416f / 256.0f;
  float3[hook(8, 2)].s0 = ((1.0f + native_cos(c)) * 0.5f) * 255;
  float3[hook(8, 2)].s1 = ((1.0f + native_cos(2.0f * c + 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 2)].s2 = ((1.0f + native_cos(c - 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 2)].s3 = 0xff;
  if (ccount.s2 == maxIterations) {
    float3[hook(8, 2)].s0 = 0;
    float3[hook(8, 2)].s1 = 0;
    float3[hook(8, 2)].s2 = 0;
  }
  if (bench) {
    float3[hook(8, 2)].s0 = ccount.s2 & 0xff;
    float3[hook(8, 2)].s1 = (ccount.s2 & 0xff00) >> 8;
    float3[hook(8, 2)].s2 = (ccount.s2 & 0xff0000) >> 16;
    float3[hook(8, 2)].s3 = (ccount.s2 & 0xff000000) >> 24;
  }
  mandelbrotImage[hook(0, 4 * tid + 2)] = float3[hook(8, 2)];
  c = fc.s3 * 2.0f * 3.1416f / 256.0f;
  float3[hook(8, 3)].s0 = ((1.0f + native_cos(c)) * 0.5f) * 255;
  float3[hook(8, 3)].s1 = ((1.0f + native_cos(2.0f * c + 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 3)].s2 = ((1.0f + native_cos(c - 2.0f * 3.1416f / 3.0f)) * 0.5f) * 255;
  float3[hook(8, 3)].s3 = 0xff;
  if (ccount.s3 == maxIterations) {
    float3[hook(8, 3)].s0 = 0;
    float3[hook(8, 3)].s1 = 0;
    float3[hook(8, 3)].s2 = 0;
  }
  if (bench) {
    float3[hook(8, 3)].s0 = ccount.s3 & 0xff;
    float3[hook(8, 3)].s1 = (ccount.s3 & 0xff00) >> 8;
    float3[hook(8, 3)].s2 = (ccount.s3 & 0xff0000) >> 16;
    float3[hook(8, 3)].s3 = (ccount.s3 & 0xff000000) >> 24;
  }
  mandelbrotImage[hook(0, 4 * tid + 3)] = float3[hook(8, 3)];
}