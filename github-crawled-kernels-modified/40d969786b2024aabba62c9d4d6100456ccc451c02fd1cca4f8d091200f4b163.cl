//{"filters":5,"images":4,"output":6,"p_filterSize":3,"p_imageSize":2,"p_numFilters":1,"p_numInputPlanes":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve_imagecubes_int(global const int* p_numInputPlanes, global const int* p_numFilters, global const int* p_imageSize, global const int* p_filterSize, global const int* images, global const int* filters, global int* output) {
  int globalId = get_global_id(0);

  int numInputPlanes = p_numInputPlanes[hook(0, 0)];
  int numFilters = p_numFilters[hook(1, 0)];
  int imageSize = p_imageSize[hook(2, 0)];
  int filterSize = p_filterSize[hook(3, 0)];
  int imageSizeSquared = imageSize * imageSize;

  int outputImage2Id = globalId / imageSizeSquared;
  int filterId = outputImage2Id % numFilters;
  int inputImage3Id = outputImage2Id / numFilters;

  int filterOffset = filterId * filterSize * filterSize;
  int inputImage3Offset = inputImage3Id * numInputPlanes * imageSizeSquared;

  int localid = globalId % imageSizeSquared;
  int row = localid / imageSize;
  int col = localid % imageSize;

  int halfFilterSize = filterSize >> 1;
  int sum = 0;
  int minm = max(-halfFilterSize, -row);
  int maxm = min(halfFilterSize, imageSize - 1 - row);
  int minn = max(-halfFilterSize, -col);
  int maxn = min(halfFilterSize, imageSize - 1 - col);
  int plane = 0;
  while (plane < numInputPlanes) {
    int inputImageOffset = inputImage3Offset + plane * imageSizeSquared;
    int filterPlaneOffset = filterOffset + plane * filterSize * filterSize;
    int m = minm;
    while (m <= maxm) {
      int y = row + m;
      int inputimagerowoffset = inputImageOffset + y * imageSize;
      int filterrowoffset = filterPlaneOffset + (m + halfFilterSize) * filterSize + halfFilterSize;
      int n = minn;
      while (n <= maxn) {
        int x = col + n;
        sum += images[hook(4, inputimagerowoffset + x)] * filters[hook(5, filterrowoffset + n)];
        n++;
      }
      m++;
    }
    plane++;
  }
  output[hook(6, globalId)] = sum;
}