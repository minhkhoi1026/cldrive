//{"dstImage":1,"edgeKernel":2,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void edgeKernel(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  const sampler_t sampler = 0 | 2 | 0x10;
  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 coords = (int2)(x, y);
  int2 curCoords = (int2)(x, y);
  int i = 0;
  int j = 0;
  float4 bufferPixel, currentPixel;
  float sum = 0;
  int counter = 0;
  const float edgeKernel[9] = {0.0f, 1.0f, 0.0f, 1.0f, -4.0f, 1.0f, 0.0f, 1.0f, 0.0f};
  currentPixel = read_imagef(srcImage, sampler, coords);
  for (i = -1; i <= 1; i++) {
    for (j = -1; j <= 1; j++) {
      coords = (int2)((x + i), (y + j));
      bufferPixel = read_imagef(srcImage, sampler, coords);
      sum = mad(bufferPixel.y, edgeKernel[hook(2, counter)], sum);
      counter++;
    }
  }
  currentPixel.x = sum;
  currentPixel.y = sum;
  currentPixel.z = sum;

  write_imagef(dstImage, curCoords, currentPixel);
}