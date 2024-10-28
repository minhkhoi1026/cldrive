//{"alphaPixel":4,"channel_ALPHA":3,"channel_IMAGEPIPELINE":2,"filmHeight":1,"filmWidth":0,"pixel":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void PremultiplyAlphaPlugin_Apply(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, global float* channel_ALPHA) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  if (!isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)])) {
    const unsigned int x = gid % filmWidth;
    const unsigned int y = gid / filmWidth;

    global float* alphaPixel = &channel_ALPHA[hook(3, gid * 2)];
    const float alpha = alphaPixel[hook(4, 0)] / alphaPixel[hook(4, 1)];

    global float* pixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];
    pixel[hook(5, 0)] *= alpha;
    pixel[hook(5, 1)] *= alpha;
    pixel[hook(5, 2)] *= alpha;
  }
}