//{"channel_IMAGEPIPELINE":2,"channel_OBJECT_ID":3,"filmHeight":1,"filmWidth":0,"objectID":4,"pixel":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ObjectIDMaskFilterPlugin_Apply(const unsigned int filmWidth, const unsigned int filmHeight, global float* channel_IMAGEPIPELINE, global unsigned int* channel_OBJECT_ID, const unsigned int objectID) {
  const size_t gid = get_global_id(0);
  if (gid >= filmWidth * filmHeight)
    return;

  const unsigned int maskValue = !isinf(channel_IMAGEPIPELINE[hook(2, gid * 3)]);
  const unsigned int objectIDValue = channel_OBJECT_ID[hook(3, gid)];
  const float value = (maskValue && (objectIDValue == objectID)) ? 1.f : 0.f;

  global float* pixel = &channel_IMAGEPIPELINE[hook(2, gid * 3)];
  pixel[hook(5, 0)] = value;
  pixel[hook(5, 1)] = value;
  pixel[hook(5, 2)] = value;
}