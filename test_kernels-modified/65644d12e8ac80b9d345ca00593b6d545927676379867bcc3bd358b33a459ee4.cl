//{"filter":3,"image":2,"p_filterSize":1,"p_imageSize":0,"result":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve_ints(global const int* p_imageSize, global const int* p_filterSize, global const int* image, global const int* filter, global int* result) {
  int id = get_global_id(0);
  int imageSize = p_imageSize[hook(0, 0)];
  int filterSize = p_filterSize[hook(1, 0)];
  int imageOffset = id / (imageSize * imageSize) * (imageSize * imageSize);
  int localid = id % (imageSize * imageSize);
  int row = localid / imageSize;
  int col = localid % imageSize;
  int halfFilterSize = filterSize >> 1;
  int sum = 0;
  int minm = max(-halfFilterSize, -row);
  int maxm = min(halfFilterSize, imageSize - 1 - row);
  int minn = max(-halfFilterSize, -col);
  int maxn = min(halfFilterSize, imageSize - 1 - col);
  int m = minm;
  while (m <= maxm) {
    int x = (row + m);
    int ximage = imageOffset + x * imageSize;
    int filterrowoffset = (m + halfFilterSize) * filterSize + halfFilterSize;
    int n = minn;
    while (n <= maxn) {
      int y = col + n;
      sum += image[hook(2, ximage + y)] * filter[hook(3, filterrowoffset + n)];
      n++;
    }
    m++;
  }
  result[hook(4, id)] = sum;
}