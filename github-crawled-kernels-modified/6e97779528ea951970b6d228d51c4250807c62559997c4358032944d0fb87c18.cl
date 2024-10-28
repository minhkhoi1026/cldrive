//{"dstImg":1,"filterSize":3,"filterValues":2,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution(read_only image2d_t srcImg, write_only image2d_t dstImg, global float* filterValues, global int* filterSize) {
  const sampler_t smp = 0 | 4 | 0x10;

  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 convPix = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float4 temp;
  uint4 pix;
  int2 coords;

  for (int local_x = 0; local_x < *filterSize; local_x++) {
    for (int local_y = 0; local_y < *filterSize; local_y++) {
      coords.x = x + local_x;
      coords.y = y + local_y;

      pix = read_imageui(srcImg, smp, coords);

      temp = (float4)((float)pix.x, (float)pix.y, (float)pix.z, (float)pix.w);
      convPix += temp * filterValues[hook(2, local_x + (*filterSize) * local_y)];
    }
  }
  coords.x = x;
  coords.y = y;

  pix = (uint4)((unsigned int)convPix.x, (unsigned int)convPix.y, (unsigned int)convPix.z, (unsigned int)convPix.w);

  write_imageui(dstImg, coords, pix);
}