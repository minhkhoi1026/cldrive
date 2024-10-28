//{"dstImage":1,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inverseKernel(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  const sampler_t sampler = 0 | 2 | 0x10;
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 coords = (int2)(x, y);

  float4 centerPixel = read_imagef(srcImage, sampler, coords);
  centerPixel.x = 1.0f - centerPixel.x;
  centerPixel.y = 1.0f - centerPixel.y;
  centerPixel.z = 1.0f - centerPixel.z;
  write_imagef(dstImage, coords, centerPixel);
}