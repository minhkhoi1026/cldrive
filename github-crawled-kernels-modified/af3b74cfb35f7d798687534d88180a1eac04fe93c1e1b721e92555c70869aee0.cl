//{"channelBufferPixel":3,"channel_IMAGEPIPELINE":2,"filmHeight":1,"filmWidth":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Film_MergeBufferFinalize(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE) {
  const size_t gid = get_global_id(0);
  if (gid > filmWidth * filmHeight)
    return;

  global float* channelBufferPixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];
  const float pixelR = channelBufferPixel[hook(3, 0)];
  const float pixelG = channelBufferPixel[hook(3, 1)];
  const float pixelB = channelBufferPixel[hook(3, 2)];

  if (isinf(pixelR))
    channelBufferPixel[hook(3, 0)] = 0.f;
  if (isinf(pixelG))
    channelBufferPixel[hook(3, 1)] = 0.f;
  if (isinf(pixelB))
    channelBufferPixel[hook(3, 2)] = 0.f;
}