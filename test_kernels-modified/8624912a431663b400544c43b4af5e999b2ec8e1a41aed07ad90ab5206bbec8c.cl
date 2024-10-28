//{"data":0,"data2":1,"kernelMatrix":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void myFilter(global uchar* data, global uchar* data2) {
  float kernelMatrix[] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
  unsigned int kernelWidth = 3;
  unsigned int kernelHeight = 3, width = 640, height = 480;
  unsigned int x = get_global_id(0);
  int y = 0;
  while (x > width) {
    x -= width;
    y++;
  }
  if (x > 5 && x < width - 5 && y > 5 && y < height - 5) {
    float rSum = 0, kSum = 0;
    for (unsigned int i = 0; i < kernelWidth; i++) {
      for (unsigned int j = 0; j < kernelHeight; j++) {
        int pixelPosX = x + (i - (kernelWidth / 2));
        int pixelPosY = y + (j - (kernelHeight / 2));

        if ((pixelPosX < 0) || (pixelPosX >= width) || (pixelPosY < 0) || (pixelPosY >= height))
          continue;

        uchar r = data[hook(0, pixelPosX + pixelPosY * width)];
        float kernelVal = kernelMatrix[hook(2, i + j * kernelWidth)];
        rSum += r * kernelVal;

        kSum += kernelVal;
      }
    }
    if (kSum == 0)
      kSum = 1;
    rSum /= kSum;
    data2[hook(1, x + y * width)] = (uchar)rSum;
  } else {
    data2[hook(1, x + y * width)] = (uchar)(250);
  }
  barrier(0x01);
}