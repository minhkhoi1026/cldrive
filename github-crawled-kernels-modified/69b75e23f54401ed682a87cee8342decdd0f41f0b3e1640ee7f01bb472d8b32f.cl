//{"dest":0,"gPyramid":19,"gPyramid0":1,"gPyramid1":2,"gPyramid2":3,"gPyramid3":4,"gPyramid4":5,"gPyramid5":6,"gPyramid6":7,"gPyramid7":8,"gPyramidLow":20,"gPyramidLow0":9,"gPyramidLow1":10,"gPyramidLow2":11,"gPyramidLow3":12,"gPyramidLow4":13,"gPyramidLow5":14,"gPyramidLow6":15,"gPyramidLow7":16,"gPyramid[li + 1]":22,"gPyramid[li]":21,"inGPyramid":17,"src":18}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float downSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(18, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(18, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(18, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(18, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(18, clamp(2 * y, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(18, clamp(2 * y, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(18, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(18, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(18, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(18, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(18, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(18, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 1 * src[hook(18, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(18, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(18, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(18, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  return sum / 64.0f;
}

float upSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(18, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 3 * src[hook(18, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2, 0, width - 1))];
  sum += 3 * src[hook(18, clamp(y / 2, 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 9 * src[hook(18, clamp(y / 2, 0, height - 1) * width + clamp(x / 2, 0, width - 1))];

  return sum / 16.0f;
}
kernel void genOutLPyramid(global float* dest, global float* gPyramid0, global float* gPyramid1, global float* gPyramid2, global float* gPyramid3, global float* gPyramid4, global float* gPyramid5, global float* gPyramid6, global float* gPyramid7, global float* gPyramidLow0, global float* gPyramidLow1, global float* gPyramidLow2, global float* gPyramidLow3, global float* gPyramidLow4, global float* gPyramidLow5, global float* gPyramidLow6, global float* gPyramidLow7, global float* inGPyramid) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  global float* gPyramid[8];
  global float* gPyramidLow[8];

  gPyramid[hook(19, 0)] = gPyramid0;
  gPyramid[hook(19, 1)] = gPyramid1;
  gPyramid[hook(19, 2)] = gPyramid2;
  gPyramid[hook(19, 3)] = gPyramid3;
  gPyramid[hook(19, 4)] = gPyramid4;
  gPyramid[hook(19, 5)] = gPyramid5;
  gPyramid[hook(19, 6)] = gPyramid6;
  gPyramid[hook(19, 7)] = gPyramid7;
  gPyramidLow[hook(20, 0)] = gPyramidLow0;
  gPyramidLow[hook(20, 1)] = gPyramidLow1;
  gPyramidLow[hook(20, 2)] = gPyramidLow2;
  gPyramidLow[hook(20, 3)] = gPyramidLow3;
  gPyramidLow[hook(20, 4)] = gPyramidLow4;
  gPyramidLow[hook(20, 5)] = gPyramidLow5;
  gPyramidLow[hook(20, 6)] = gPyramidLow6;
  gPyramidLow[hook(20, 7)] = gPyramidLow7;

  float level = inGPyramid[hook(17, y * width + x)] * (8 - 1);
  int li = clamp((int)level, 0, 8 - 2);
  float lf = level - (float)li;
  float lPyramid1 = gPyramid[hook(19, li)][hook(21, y * width + x)] - upSample(x, y, width / 2, height / 2, gPyramidLow[hook(20, li)]);
  float lPyramid2 = gPyramid[hook(19, li + 1)][hook(22, y * width + x)] - upSample(x, y, width / 2, height / 2, gPyramidLow[hook(20, li + 1)]);
  dest[hook(0, y * width + x)] = (1.0f - lf) * lPyramid1 + lf * lPyramid2;
}