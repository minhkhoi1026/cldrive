//{"backup":5,"height":2,"io":0,"pixelArr":6,"start":3,"template":4,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void borderline(global float* io, const int width, const int height, const int start, global int* template, global float* backup) {
  int ix = get_global_id(0);
  int iy = get_global_id(1);
  int realI = (iy * width + ix) * 4;

  if (ix == 0 || iy == 0 || ix == width - 1 || iy == height - 1) {
    io[hook(0, realI + 0)] = 256;
    io[hook(0, realI + 1)] = 256;
    io[hook(0, realI + 2)] = 256;
    io[hook(0, realI + 3)] = 256;
    return;
  }

  if (ix >= width || iy >= height)
    return;

  float pixelArr[3 * 9] = {0};
  for (int k = start; k <= -start; k++) {
    int currRow = iy + k;
    for (int kk = start; kk <= -start; kk++) {
      int currCol = ix + kk;
      int currI = (currRow * width + currCol) * 4;
      for (int j = 0; j < 3; j++) {
        int tempI = currI + j;
        if (tempI <= (width * height - 1) * 4) {
          int index = (k - start) * (2 * (-start) + 1) + (kk - start);
          pixelArr[hook(6, j * 9 + index)] = backup[hook(5, tempI)];
        }
      }
    }
  }

  for (int j = 0; j < 3; j++) {
    io[hook(0, realI + j)] = 0;
    for (int i = 0; i < 9; i++) {
      io[hook(0, realI + j)] += pixelArr[hook(6, j * 9 + i)] * template[hook(4, i)];
    }
  }
  io[hook(0, realI + 3)] = 256;
}