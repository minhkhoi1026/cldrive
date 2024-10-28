//{"destination":1,"destinationPitch":2,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t samp = 0 | 0x10 | 0;
kernel void convertImageRgbaToBufferRgb(read_only image2d_t source, global uchar* destination, int destinationPitch) {
  const int2 gid = {get_global_id(0), get_global_id(1)};
  const int2 size = get_image_dim(source);

  if (!all(gid < size))
    return;

  float3 rgb = read_imagef(source, samp, gid).xyz;
  rgb *= (float3)(255.0f, 255.0f, 255.0f);

  int firstCoord = mad24(gid.y, destinationPitch, 3 * gid.x);

  destination[hook(1, firstCoord + 0)] = (uchar)rgb.z;
  destination[hook(1, firstCoord + 1)] = (uchar)rgb.y;
  destination[hook(1, firstCoord + 2)] = (uchar)rgb.x;
}