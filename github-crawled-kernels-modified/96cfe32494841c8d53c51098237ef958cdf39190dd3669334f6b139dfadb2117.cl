//{"dest":0,"gPyramid":11,"gPyramid0":1,"gPyramid1":2,"gPyramid2":3,"gPyramid3":4,"gPyramid4":5,"gPyramid5":6,"gPyramid6":7,"gPyramid7":8,"gPyramid[li + 1]":13,"gPyramid[li]":12,"inGPyramid":9,"src":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float downSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(10, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(10, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(10, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(10, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(10, clamp(2 * y, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(10, clamp(2 * y, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(10, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(10, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(10, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(10, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(10, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(10, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 1 * src[hook(10, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(10, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(10, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(10, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  return sum / 64.0f;
}

float upSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(10, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 3 * src[hook(10, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2, 0, width - 1))];
  sum += 3 * src[hook(10, clamp(y / 2, 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 9 * src[hook(10, clamp(y / 2, 0, height - 1) * width + clamp(x / 2, 0, width - 1))];

  return sum / 16.0f;
}
kernel void genOutLPyramidLowest(global float* dest, global float* gPyramid0, global float* gPyramid1, global float* gPyramid2, global float* gPyramid3, global float* gPyramid4, global float* gPyramid5, global float* gPyramid6, global float* gPyramid7, global float* inGPyramid) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  global float* gPyramid[8];

  gPyramid[hook(11, 0)] = gPyramid0;
  gPyramid[hook(11, 1)] = gPyramid1;
  gPyramid[hook(11, 2)] = gPyramid2;
  gPyramid[hook(11, 3)] = gPyramid3;
  gPyramid[hook(11, 4)] = gPyramid4;
  gPyramid[hook(11, 5)] = gPyramid5;
  gPyramid[hook(11, 6)] = gPyramid6;
  gPyramid[hook(11, 7)] = gPyramid7;

  float level = inGPyramid[hook(9, y * width + x)] * (8 - 1);
  int li = clamp((int)level, 0, 8 - 2);
  float lf = level - (float)li;
  float lPyramid1 = gPyramid[hook(11, li)][hook(12, y * width + x)];
  float lPyramid2 = gPyramid[hook(11, li + 1)][hook(13, y * width + x)];
  dest[hook(0, y * width + x)] = (1.0f - lf) * lPyramid1 + lf * lPyramid2;
}