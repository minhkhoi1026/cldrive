//{"channel_IMAGEPIPELINE":2,"filmHeight":1,"filmWidth":0,"pixel":4,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void LuxLinearToneMap_Apply(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, const float scale) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  if (!isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)])) {
    global float* pixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];

    pixel[hook(4, 0)] *= scale;
    pixel[hook(4, 1)] *= scale;
    pixel[hook(4, 2)] *= scale;
  }
}