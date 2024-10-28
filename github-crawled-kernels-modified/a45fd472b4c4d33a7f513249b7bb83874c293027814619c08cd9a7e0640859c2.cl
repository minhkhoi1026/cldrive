//{"channel_IMAGEPIPELINE":2,"filmHeight":1,"filmWidth":0,"pixel":4,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VignettingPlugin_Apply(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, const float scale) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  if (!isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)])) {
    const unsigned int x = gid % filmWidth;
    const unsigned int y = gid / filmWidth;
    const float nx = x / (float)filmWidth;
    const float ny = y / (float)filmHeight;
    const float xOffset = (nx - .5f) * 2.f;
    const float yOffset = (ny - .5f) * 2.f;
    const float tOffset = sqrt(xOffset * xOffset + yOffset * yOffset);

    const float invOffset = 1.f - (fabs(tOffset) * 1.42f);
    float vWeight = mix(1.f - scale, 1.f, invOffset);

    global float* pixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];
    pixel[hook(4, 0)] *= vWeight;
    pixel[hook(4, 1)] *= vWeight;
    pixel[hook(4, 2)] *= vWeight;
  }
}