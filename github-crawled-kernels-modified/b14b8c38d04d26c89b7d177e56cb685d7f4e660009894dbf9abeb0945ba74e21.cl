//{"dest":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float downSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(1, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(1, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(1, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(1, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(1, clamp(2 * y, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(1, clamp(2 * y, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(1, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(1, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(1, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(1, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(1, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(1, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 1 * src[hook(1, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(1, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(1, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(1, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  return sum / 64.0f;
}

float upSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(1, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 3 * src[hook(1, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2, 0, width - 1))];
  sum += 3 * src[hook(1, clamp(y / 2, 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 9 * src[hook(1, clamp(y / 2, 0, height - 1) * width + clamp(x / 2, 0, width - 1))];

  return sum / 16.0f;
}
kernel void downSampleKernel(global float* dest, global float* src) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);

  dest[hook(0, y * width + x)] = downSample(x, y, width * 2, height * 2, src);
}