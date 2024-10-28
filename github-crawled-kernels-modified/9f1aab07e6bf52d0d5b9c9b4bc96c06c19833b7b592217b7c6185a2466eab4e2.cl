//{"bloomBuffer":3,"bloomWeight":4,"channel_IMAGEPIPELINE":2,"dst":6,"filmHeight":1,"filmWidth":0,"src":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BloomFilterPlugin_Merge(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, global float* bloomBuffer, const float bloomWeight) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  if (!isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)])) {
    global float* src = &channel_IMAGEPIPELINE[hook(2, gid * 3)];
    global float* dst = &bloomBuffer[hook(3, gid * 3)];

    src[hook(5, 0)] = mix(src[hook(5, 0)], dst[hook(6, 0)], bloomWeight);
    src[hook(5, 1)] = mix(src[hook(5, 1)], dst[hook(6, 1)], bloomWeight);
    src[hook(5, 2)] = mix(src[hook(5, 2)], dst[hook(6, 2)], bloomWeight);
  }
}