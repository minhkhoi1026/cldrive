//{"coordY":9,"dstPitch":5,"dstUV":4,"dstY":3,"pD":8,"param1":6,"param2":7,"srcPitch":2,"srcUV":1,"srcY":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t smp = 0x10;
kernel void ProcessUV(read_only image2d_t srcY, read_only image2d_t srcUV, int srcPitch, write_only image2d_t dstY, write_only image2d_t dstUV, int dstPitch, int param1, int param2, global float2* pD) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int w = get_global_size(0);
  int h = get_global_size(1);
  float2 p = (float2)(x, y);
  float2 d = (2.0f * p - pD[hook(8, 0)]);
  float2 param = pD[hook(8, 1)];
  int2 coordUV = (int2)(x, y);
  int2 coordY[4] = {(int2)(2 * x, 2 * y), (int2)(2 * x + 1, 2 * y), (int2)(2 * x, 2 * y + 1), (int2)(2 * x + 1, 2 * y + 1)};

  float4 UV, Y0, Y1, Y2, Y3;
  UV = read_imagef(srcUV, smp, coordUV);
  Y0 = read_imagef(srcY, smp, coordY[hook(9, 0)]);
  Y1 = read_imagef(srcY, smp, coordY[hook(9, 1)]);
  Y2 = read_imagef(srcY, smp, coordY[hook(9, 2)]);
  Y3 = read_imagef(srcY, smp, coordY[hook(9, 3)]);

  if (dot(d, d) < (400.0f * 400.0f)) {
    UV.x = (UV.x - 0.5f) * param.y + 0.5f;
    UV.y = (UV.y - 0.5f) * param.y + 0.5f;
    Y0.x = (Y0.x - 0.5f) * param.x + 0.5f;
    Y1.x = (Y1.x - 0.5f) * param.x + 0.5f;
    Y2.x = (Y2.x - 0.5f) * param.x + 0.5f;
    Y3.x = (Y3.x - 0.5f) * param.x + 0.5f;
  }

  write_imagef(dstUV, coordUV, UV);
  write_imagef(dstY, coordY[hook(9, 0)], Y0);
  write_imagef(dstY, coordY[hook(9, 1)], Y1);
  write_imagef(dstY, coordY[hook(9, 2)], Y2);
  write_imagef(dstY, coordY[hook(9, 3)], Y3);
}