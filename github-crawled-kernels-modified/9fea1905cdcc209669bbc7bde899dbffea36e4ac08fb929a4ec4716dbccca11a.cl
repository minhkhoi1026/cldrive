//{"dst":3,"filmHeight":1,"filmWidth":0,"src":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void OptixDenoiserPlugin_BufferSetUp(const unsigned int filmWidth, const unsigned int filmHeight, global float* src, global float* dst) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  const unsigned int index4 = gid * 4;
  const float x = src[hook(2, index4)];
  const float y = src[hook(2, index4 + 1)];
  const float z = src[hook(2, index4 + 2)];
  const float w = 1.f / src[hook(2, index4 + 3)];

  const unsigned int index3 = gid * 3;
  dst[hook(3, index3)] = x * w;
  dst[hook(3, index3 + 1)] = y * w;
  dst[hook(3, index3 + 2)] = z * w;
}