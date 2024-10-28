//{"dstImage":1,"sharpenKernel":2,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sharpenKernel(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  const sampler_t sampler = 0 | 2 | 0x10;
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 coords = (int2)(x, y);
  int2 curCoords = (int2)(x, y);
  int i = 0;
  int j = 0;
  float4 bufferPixel, curPix;
  int counter;
  const float sharpenKernel[9] = {0.0f, -1.0f, 0.0f, -1.0f, 5.0f, -1.0f, 0.0f, -1.0f, 0.0f};
  counter = 0;
  curPix = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (i = -1; i <= 1; i++) {
    for (j = -1; j <= 1; j++) {
      coords = (int2)((x + i), (y + j));
      bufferPixel = read_imagef(srcImage, sampler, coords);
      curPix += bufferPixel * sharpenKernel[hook(2, counter)];
      counter++;
    }
  }

  curPix.w = 1.0f;

  write_imagef(dstImage, curCoords, curPix);
}