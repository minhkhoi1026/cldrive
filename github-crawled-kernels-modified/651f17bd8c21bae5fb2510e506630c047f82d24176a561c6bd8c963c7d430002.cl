//{"dstImage":1,"list":2,"pixelListB":5,"pixelListG":4,"pixelListR":3,"srcImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void bubble_sort(float list[], float n) {
  int c, d;
  float t;

  for (c = 1; c <= n - 1; c++) {
    d = c;

    while (d > 0 && list[hook(2, d)] < list[hook(2, d - 1)]) {
      t = list[hook(2, d)];
      list[hook(2, d)] = list[hook(2, d - 1)];
      list[hook(2, d - 1)] = t;

      d--;
    }
  }
}

kernel void mediaanKernel(read_only image2d_t srcImage, write_only image2d_t dstImage) {
  const sampler_t sampler = 1 | 6 | 0x10;

  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 coords = (int2)(x, y);

  int counter = 0;
  float pixelListR[25];
  float pixelListG[25];
  float pixelListB[25];

  int i = 0;
  int j = 0;

  float4 bufferPixel;

  for (i = -2; i <= 2; i++) {
    for (j = -2; j <= 2; j++) {
      coords = (int2)((x + i), (y + j));
      bufferPixel = read_imagef(srcImage, sampler, coords);

      pixelListR[hook(3, counter)] = bufferPixel.x;
      pixelListG[hook(4, counter)] = bufferPixel.y;
      pixelListB[hook(5, counter)] = bufferPixel.z;

      counter++;
    }
  }

  bubble_sort(pixelListR, 25);
  bubble_sort(pixelListG, 25);
  bubble_sort(pixelListB, 25);

  float4 result = {0, 0, 0, 255};
  result.x = pixelListR[hook(3, 12)];
  result.y = pixelListG[hook(4, 12)];
  result.z = pixelListB[hook(5, 12)];
  coords = (int2)(x, y);
  write_imagef(dstImage, coords, result);
}