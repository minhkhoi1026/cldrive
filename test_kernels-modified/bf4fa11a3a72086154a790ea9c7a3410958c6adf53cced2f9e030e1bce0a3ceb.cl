//{"height":2,"iter":7,"maxIterations":6,"offsetX":4,"offsetY":5,"pixels":0,"scale":3,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandelGPU(global int* pixels, const int width, const int height, const float scale, const float offsetX, const float offsetY, const int maxIterations) {
  const int gid = get_global_id(0);
  const int gid4 = 4 * gid;
  const int maxSize = max(width, height);
  const float kx = (scale / 2.f) * width;
  const float ky = (scale / 2.f) * height;

  int t;
  unsigned int iter[4];
  for (t = 0; t < 4; ++t) {
    const int tid = gid4 + t;

    const int screenX = tid % width;
    const int screenY = tid / width;

    if (screenY >= height)
      return;

    const float x0 = ((screenX * scale) - kx) / maxSize + offsetX;
    const float y0 = ((screenY * scale) - ky) / maxSize + offsetY;

    float x = x0;
    float y = y0;
    float x2 = x * x;
    float y2 = y * y;
    for (iter[hook(7, t)] = 0; (x2 + y2 <= 4.f) && (iter[hook(7, t)] < maxIterations); ++iter[hook(7, t)]) {
      y = 2 * x * y + y0;
      x = x2 - y2 + x0;

      x2 = x * x;
      y2 = y * y;
    }

    if (iter[hook(7, t)] == maxIterations)
      iter[hook(7, t)] = 0;
    else {
      iter[hook(7, t)] = iter[hook(7, t)] % 512;
      if (iter[hook(7, t)] > 255)
        iter[hook(7, t)] = 511 - iter[hook(7, t)];
    }
  }

  pixels[hook(0, gid)] = iter[hook(7, 0)] | (iter[hook(7, 1)] << 8) | (iter[hook(7, 2)] << 16) | (iter[hook(7, 3)] << 24);
}