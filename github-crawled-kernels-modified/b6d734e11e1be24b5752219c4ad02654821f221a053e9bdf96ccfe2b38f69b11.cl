//{"channel_IMAGEPIPELINE":2,"filmHeight":1,"filmWidth":0,"gamma":3,"pixel":5,"totalRGB":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AutoLinearToneMap_Apply(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, const float gamma, global float* totalRGB) {
  const size_t gid = get_global_id(0);
  const unsigned int pixelCount = filmWidth * filmHeight;
  if (gid >= pixelCount)
    return;

  if (!isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)])) {
    const float totalLuminance = .212671f * totalRGB[hook(4, 0)] + .715160f * totalRGB[hook(4, 1)] + .072169f * totalRGB[hook(4, 2)];
    const float avgLuminance = totalLuminance / pixelCount;
    const float scale = (avgLuminance > 0.f) ? (1.25f / avgLuminance * native_powr(118.f / 255.f, gamma)) : 1.f;

    global float* pixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];
    pixel[hook(5, 0)] *= scale;
    pixel[hook(5, 1)] *= scale;
    pixel[hook(5, 2)] *= scale;
  }
}