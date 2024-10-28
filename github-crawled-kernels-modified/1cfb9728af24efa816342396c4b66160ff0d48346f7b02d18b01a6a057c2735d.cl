//{"dstPitch":5,"dstUV":4,"dstY":3,"p1":6,"p2":7,"pC":9,"pData":8,"pP":10,"srcPitch":2,"srcUV":1,"srcY":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smp = 0x10;
kernel void ProcessUV(read_only image2d_t srcY, read_only image2d_t srcUV, int srcPitch, write_only image2d_t dstY, write_only image2d_t dstUV, int dstPitch, int p1, int p2, global int* pData) {
  int x2 = get_global_id(0);
  int y2 = get_global_id(1);
  int w2 = get_global_size(0);
  int h2 = get_global_size(1);
  int w4 = w2 >> 1;
  int h4 = h2 >> 1;
  int x4 = x2 >> 1;
  int y4 = y2 >> 1;
  int2 pd = (int2)(x2, y2);
  if (x4 > 0 & x4<(w4 - 1) & y4> 0 & y4 < (h4 - 1)) {
    int f = pData[hook(8, 0)] & 1;
    global float* pD = (global float*)(pData + 32);
    global float* pC = pD + (w4 * h4) * f + x4 + y4 * w4;
    global float* pP = pD + (w4 * h4) * (1 - f) + x4 + y4 * w4;
    if ((x2 & 1) & (y2 & 1)) {
      float L = 4 * pC[hook(9, 0)] - (pC[hook(9, -1)] + pC[hook(9, +1)] + pC[hook(9, w4)] + pC[hook(9, -w4)]);
      pP[hook(10, 0)] = 2 * pC[hook(9, 0)] - pP[hook(10, 0)] - (0.7f * 0.7f) * L - 0.00005f * p1 * (pC[hook(9, 0)] - pP[hook(10, 0)]);
    }

    float x2r = 0.5f * (x2 & 1);
    float y2r = 0.5f * (y2 & 1);
    float dx2 = 0.25f * ((pC[hook(9, 0)] - pC[hook(9, -1)]) * (1 - x2r) * (1 - y2r) + (pC[hook(9, 1)] - pC[hook(9, 0)]) * (x2r) * (1 - y2r) + (pC[hook(9, w4 + 0)] - pC[hook(9, w4 - 1)]) * (1 - x2r) * (y2r) + (pC[hook(9, w4 + 1)] - pC[hook(9, w4 + 0)]) * (x2r) * (y2r));
    float dy2 = 0.25f * ((pC[hook(9, 0)] - pC[hook(9, -w4)]) * (1 - x2r) * (1 - y2r) + (pC[hook(9, 1)] - pC[hook(9, 1 - w4)]) * (x2r) * (1 - y2r) + (pC[hook(9, w4)] - pC[hook(9, 0)]) * (1 - x2r) * (y2r) + (pC[hook(9, w4 + 1)] - pC[hook(9, 1)]) * (x2r) * (y2r));
    int2 ps = (int2)(clamp(x2 + (int)dx2, 0, w2 - 2), clamp(y2 + (int)dy2, 0, h2 - 2));

    write_imagef(dstUV, pd, read_imagef(srcUV, smp, ps));
    pd *= 2;
    ps *= 2;
    int2 xy;
    xy = (int2)(0, 0);
    write_imagef(dstY, pd + xy, read_imagef(srcY, smp, ps + xy));
    xy = (int2)(0, 1);
    write_imagef(dstY, pd + xy, read_imagef(srcY, smp, ps + xy));
    xy = (int2)(1, 0);
    write_imagef(dstY, pd + xy, read_imagef(srcY, smp, ps + xy));
    xy = (int2)(1, 1);
    write_imagef(dstY, pd + xy, read_imagef(srcY, smp, ps + xy));
  }
}