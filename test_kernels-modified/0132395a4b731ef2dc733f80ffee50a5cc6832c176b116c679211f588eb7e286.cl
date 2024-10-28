//{"G":1,"H":3,"W":2,"image":0,"newImg":5,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussian_blur(global const unsigned char* image, global const float* G, const int W, const int H, const int size, global unsigned char* newImg) {
  unsigned int x, y, imgLineSize;
  float value;
  int i, xOff, yOff, center;

  i = get_global_id(0);

  imgLineSize = W * 3;
  center = size / 2;

  if (i >= imgLineSize * (size - center) + center * 3 && i < W * H * 3 - imgLineSize * (size - center) - center * 3) {
    value = 0;
    for (y = 0; y < size; y++) {
      yOff = imgLineSize * (y - center);
      for (x = 0; x < size; x++) {
        xOff = 3 * (x - center);
        value += G[hook(1, y * size + x)] * image[hook(0, i + xOff + yOff)];
      }
    }
    newImg[hook(5, i)] = value;
  } else {
    newImg[hook(5, i)] = image[hook(0, i)];
  }
}