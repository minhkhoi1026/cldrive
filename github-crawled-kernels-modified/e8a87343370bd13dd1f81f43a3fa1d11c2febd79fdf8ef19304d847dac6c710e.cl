//{"UVIn":3,"UVOut":2,"YIn":1,"YOut":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_invert_shared(write_only image2d_t YOut, read_only image2d_t YIn, write_only image2d_t UVOut, read_only image2d_t UVIn) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 pixel = (float4)0;

  int2 coord = (int2)(x, y);
  const sampler_t smp = 0x10;

  pixel = read_imagef(YIn, smp, coord);
  pixel = (float4)1.0 - pixel;
  write_imagef(YOut, coord, pixel);

  if (x % 2 == 0 && y % 2 == 0) {
    int2 coordUV = (int2)(x / 2, y / 2);
    pixel = read_imagef(UVIn, smp, coordUV);
    pixel = (float4)1.0 - pixel;
    write_imagef(UVOut, coordUV, pixel);
  }
}