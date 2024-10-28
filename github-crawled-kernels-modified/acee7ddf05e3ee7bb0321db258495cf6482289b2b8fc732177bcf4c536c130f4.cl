//{"UVIn":3,"UVOut":2,"YIn":1,"YOut":0,"guassianKernal":5,"guassianKernal[j]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_gauss_shared(write_only image2d_t YOut, read_only image2d_t YIn, write_only image2d_t UVOut, read_only image2d_t UVIn) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float4 pixel = (float4)0;
  float4 float3;

  int2 coord = (int2)(x, y);
  const sampler_t smp = 0x10;

  float guassianKernal[3][3] = {{0.09880393805197481, 0.11672306104983232, 0.09880393805197481}, {0.11672306104983232, 0.13789200359277154, 0.11672306104983232}, {0.09880393805197481, 0.11672306104983232, 0.09880393805197481}};

  int kernalHeight = 3;
  int kernalWidth = 3;

  int kernalOffsetX = kernalWidth / 2;
  int kernalOffsetY = kernalHeight / 2;

  float R, G, B;

  float totalR, totalG, totalB;
  totalR = 0;
  totalG = 0;
  totalB = 0;

  if (x == 0 || x == 1 || x == 639 || x == 640 || y == 0 || y == 1 || y == 479 || y == 480) {
    coord.x = x;
    coord.y = y;
    pixel = read_imagef(YIn, smp, coord);

    totalR = totalR + pixel.x;
    totalG = totalG + pixel.y;
    totalB = totalB + pixel.z;
  } else {
    for (int i = 0; i < kernalHeight; i++) {
      for (int j = 0; j < kernalWidth; j++) {
        coord.x = x - kernalOffsetX + j;
        coord.y = y - kernalOffsetY + i;
        pixel = read_imagef(YIn, smp, coord);

        totalR = totalR + pixel.x * guassianKernal[hook(5, j)][hook(4, i)];
        totalG = totalG + pixel.y * guassianKernal[hook(5, j)][hook(4, i)];
        totalB = totalB + pixel.z * guassianKernal[hook(5, j)][hook(4, i)];
      }
    }
  }

  float4 finalColor;

  finalColor.x = totalR;
  finalColor.y = totalG;
  finalColor.z = totalB;
  finalColor.w = 0;
  coord.x = x;
  coord.y = y;
  write_imagef(YOut, coord, finalColor);

  totalR = 0;
  totalG = 0;
  totalB = 0;

  int uvX = x / 2;
  int uvY = y / 2;

  if (x % 2 == 0 && y % 2 == 0) {
    if (x == 0 || x == 1 || x == 639 || x == 640 || y == 0 || y == 1 || y == 479 || y == 480) {
      coord.x = uvX;
      coord.y = uvY;
      pixel = read_imagef(UVIn, smp, coord);

      totalR = totalR + pixel.x;
      totalG = totalG + pixel.y;
      totalB = totalB + pixel.z;

    } else {
      for (int i = 0; i < kernalHeight; i++) {
        for (int j = 0; j < kernalWidth; j++) {
          coord.x = uvX - kernalOffsetX + j;
          coord.y = uvY - kernalOffsetY + i;
          pixel = read_imagef(UVIn, smp, coord);

          totalR = totalR + pixel.x * guassianKernal[hook(5, j)][hook(4, i)];
          totalG = totalG + pixel.y * guassianKernal[hook(5, j)][hook(4, i)];
          totalB = totalB + pixel.z * guassianKernal[hook(5, j)][hook(4, i)];
        }
      }
    }

    coord.x = uvX;
    coord.y = uvY;
    finalColor.x = totalR;
    finalColor.y = totalG;
    finalColor.z = totalB;
    write_imagef(UVOut, coord, finalColor);
  }
}