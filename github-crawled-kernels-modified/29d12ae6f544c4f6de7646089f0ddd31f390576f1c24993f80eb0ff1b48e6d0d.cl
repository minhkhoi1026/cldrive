//{"sliceNr":2,"texture":1,"volume":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void renderSliceToTexture(read_only image3d_t volume, write_only image2d_t texture, private int sliceNr) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = sliceNr;

  unsigned char value = read_imageui(volume, sampler, (int4)(x, y, z, 0)).x;

  write_imagef(texture, (int2)(get_global_size(0) - x - 1, get_global_size(1) - y - 1), (float4)(0.0, 1.0, 0.0, 1.0));
}