//{"dest":0,"outGPyramidLow":1,"outLPyramid":2,"src":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float downSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(3, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(3, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(3, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(3, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(3, clamp(2 * y, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(3, clamp(2 * y, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(3, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(3, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(3, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(3, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(3, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(3, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 1 * src[hook(3, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(3, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(3, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(3, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  return sum / 64.0f;
}

float upSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(3, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 3 * src[hook(3, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2, 0, width - 1))];
  sum += 3 * src[hook(3, clamp(y / 2, 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 9 * src[hook(3, clamp(y / 2, 0, height - 1) * width + clamp(x / 2, 0, width - 1))];

  return sum / 16.0f;
}
kernel void genOutGPyramid(global float* dest, global float* outGPyramidLow, global float* outLPyramid) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);

  dest[hook(0, y * width + x)] = upSample(x, y, width / 2, height / 2, outGPyramidLow) + outLPyramid[hook(2, y * width + x)];
}