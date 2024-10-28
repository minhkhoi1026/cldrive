//{"dest":0,"floating":2,"gray":3,"outGPyramid":1,"src":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float downSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(4, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(4, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(4, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(4, clamp(2 * y - 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(4, clamp(2 * y, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(4, clamp(2 * y, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(4, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(4, clamp(2 * y, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 3 * src[hook(4, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 9 * src[hook(4, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 9 * src[hook(4, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 3 * src[hook(4, clamp(2 * y + 1, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  sum += 1 * src[hook(4, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x - 1, 0, width - 1))];
  sum += 3 * src[hook(4, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x, 0, width - 1))];
  sum += 3 * src[hook(4, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 1, 0, width - 1))];
  sum += 1 * src[hook(4, clamp(2 * y + 2, 0, height - 1) * width + clamp(2 * x + 2, 0, width - 1))];

  return sum / 64.0f;
}

float upSample(int x, int y, int width, int height, global float* src) {
  float sum = 0.0f;

  sum += 1 * src[hook(4, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 3 * src[hook(4, clamp(y / 2 - 1 + 2 * (y % 2), 0, height - 1) * width + clamp(x / 2, 0, width - 1))];
  sum += 3 * src[hook(4, clamp(y / 2, 0, height - 1) * width + clamp(x / 2 - 1 + 2 * (x % 2), 0, width - 1))];
  sum += 9 * src[hook(4, clamp(y / 2, 0, height - 1) * width + clamp(x / 2, 0, width - 1))];

  return sum / 16.0f;
}
kernel void genOutput(global uchar* dest, global float* outGPyramid, global float* floating, global float* gray) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  int width = get_global_size(0);
  const float eps = 0.01f;

  float float3 = outGPyramid[hook(1, y * width + x)] * (floating[hook(2, y * width + x)] + eps) / (gray[hook(3, y * width + x)] + eps);
  dest[hook(0, y * width + x)] = (uchar)(clamp(float3, 0.0f, 1.0f) * 255.0f);
}