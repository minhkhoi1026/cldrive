//{"destination":2,"source":0,"sourcePitch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convertBufferRgbToImageRgba(global uchar* source, int sourcePitch, write_only image2d_t destination) {
  const int2 gid = {get_global_id(0), get_global_id(1)};
  const int2 size = get_image_dim(destination);

  if (!all(gid < size))
    return;

  int firstCoord = mad24(gid.y, sourcePitch, 3 * gid.x);

  float b = source[hook(0, firstCoord + 0)] * (1.0f / 255.0f);
  float g = source[hook(0, firstCoord + 1)] * (1.0f / 255.0f);
  float r = source[hook(0, firstCoord + 2)] * (1.0f / 255.0f);

  write_imagef(destination, gid, (float4)(r, g, b, 1.0f));
}