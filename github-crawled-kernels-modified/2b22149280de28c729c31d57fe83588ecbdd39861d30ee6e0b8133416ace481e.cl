//{"backup":6,"gaussMatrix":5,"height":2,"io":0,"radius":3,"sigma":4,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussBlurX(global float* io, const int width, const int height, const int radius, const float sigma, global float* gaussMatrix, global float* backup) {
  int ix = get_global_id(0);
  int iy = get_global_id(1);
  int i = (iy * width + ix) * 4;
  int ii;
  int k;
  float gaussSum = 0;
  float r = 0;
  float g = 0;
  float b = 0;
  float a = 0;
  for (int j = -radius; j <= radius; j++) {
    k = ix + j;
    if (k >= 0 && k < width) {
      ii = (iy * width + k) * 4;
      r += backup[hook(6, ii)] * gaussMatrix[hook(5, j + radius)];
      g += backup[hook(6, ii + 1)] * gaussMatrix[hook(5, j + radius)];
      b += backup[hook(6, ii + 2)] * gaussMatrix[hook(5, j + radius)];
      gaussSum += gaussMatrix[hook(5, j + radius)];
    }
  }
  io[hook(0, i)] = r / gaussSum;
  io[hook(0, i + 1)] = g / gaussSum;
  io[hook(0, i + 2)] = b / gaussSum;
}