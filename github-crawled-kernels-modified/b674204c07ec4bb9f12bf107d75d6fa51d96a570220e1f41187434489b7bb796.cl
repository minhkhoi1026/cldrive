//{"channel_IMAGEPIPELINE":2,"filmHeight":1,"filmWidth":0,"pixel":6,"scaleB":5,"scaleG":4,"scaleR":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void WhiteBalance_Apply(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, const float scaleR, const float scaleG, const float scaleB) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  if (!isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)])) {
    global float* pixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];

    pixel[hook(6, 0)] *= scaleR;
    pixel[hook(6, 1)] *= scaleG;
    pixel[hook(6, 2)] *= scaleB;
  }
}