//{"channelBufferPixel":8,"channel_IMAGEPIPELINE":2,"filmHeight":1,"filmWidth":0,"mergeBuffer":3,"mergeBufferPixel":7,"scaleB":6,"scaleG":5,"scaleR":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Film_MergeRADIANCE_PER_SCREEN_NORMALIZED(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, global float* mergeBuffer, const float scaleR, const float scaleG, const float scaleB) {
  const size_t gid = get_global_id(0);
  if (gid > filmWidth * filmHeight)
    return;

  global const float* mergeBufferPixel = &mergeBuffer[hook(3, gid * 3)];
  float r = mergeBufferPixel[hook(7, 0)];
  float g = mergeBufferPixel[hook(7, 1)];
  float b = mergeBufferPixel[hook(7, 2)];

  if ((r != 0.f) || (g != 0.f) || (b != 0.f)) {
    r *= scaleR;
    g *= scaleG;
    b *= scaleB;

    global float* channelBufferPixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];
    const float pixelR = channelBufferPixel[hook(8, 0)];
    const float pixelG = channelBufferPixel[hook(8, 1)];
    const float pixelB = channelBufferPixel[hook(8, 2)];

    channelBufferPixel[hook(8, 0)] = isinf(pixelR) ? r : (pixelR + r);
    channelBufferPixel[hook(8, 1)] = isinf(pixelG) ? g : (pixelG + g);
    channelBufferPixel[hook(8, 2)] = isinf(pixelB) ? b : (pixelB + b);
  }
}