//{"bloomBuffer":3,"bloomBufferTmp":4,"bloomFilter":5,"bloomWidth":6,"channel_IMAGEPIPELINE":2,"dst":7,"filmHeight":1,"filmWidth":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BloomFilterPlugin_FilterX(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, global float* bloomBuffer, global float* bloomBufferTmp, global float* bloomFilter, const unsigned int bloomWidth) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  const unsigned int x = gid % filmWidth;
  const unsigned int y = gid / filmWidth;

  if (!isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)])) {
    const unsigned int x0 = max(x, bloomWidth) - bloomWidth;
    const unsigned int x1 = min(x + bloomWidth, filmWidth - 1);

    float sumWt = 0.f;
    const unsigned int by = y;
    float3 pixel = 0;
    for (unsigned int bx = x0; bx <= x1; ++bx) {
      const unsigned int bloomOffset = bx + by * filmWidth;

      if (!isinf(channel_IMAGEPIPELINE[hook(2, bloomOffset)])) {
        const unsigned int dist2 = (x - bx) * (x - bx) + (y - by) * (y - by);
        const float wt = bloomFilter[hook(5, dist2)];
        if (wt == 0.f)
          continue;

        sumWt += wt;
        const unsigned int bloomOffset3 = bloomOffset * 3;
        pixel.x += wt * channel_IMAGEPIPELINE[hook(2, bloomOffset3)];
        pixel.y += wt * channel_IMAGEPIPELINE[hook(2, bloomOffset3 + 1)];
        pixel.z += wt * channel_IMAGEPIPELINE[hook(2, bloomOffset3 + 2)];
      }
    }
    if (sumWt > 0.f)
      pixel /= sumWt;

    global float* dst = &bloomBufferTmp[hook(4, (x + y * filmWidth) * 3)];
    dst[hook(7, 0)] = pixel.x;
    dst[hook(7, 1)] = pixel.y;
    dst[hook(7, 2)] = pixel.z;
  }
}