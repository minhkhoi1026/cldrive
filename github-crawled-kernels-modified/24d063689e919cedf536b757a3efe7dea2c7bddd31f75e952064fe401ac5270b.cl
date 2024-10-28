//{"filterSize":3,"filters":5,"imageSize":2,"images":4,"numFilters":1,"numInputPlanes":0,"output":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve_imagecubes_float(const int numInputPlanes, const int numFilters, const int imageSize, const int filterSize, global const float* images, global const float* filters, global float* output) {
  int globalId = get_global_id(0);

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
  float sum = 0;

  int minm = max(-halfFilterSize, -row);
  int maxm = min(halfFilterSize, imageSize - 1 - row);
  int minn = max(-halfFilterSize, -col);
  int maxn = min(halfFilterSize, imageSize - 1 - col);
  int inputPlane = 0;
  while (inputPlane < numInputPlanes) {
    int inputImageOffset = inputImage3Offset + inputPlane * imageSizeSquared;
    int m = minm;
    while (m <= maxm) {
      int y = row + m;
      int inputimagerowoffset = inputImageOffset + y * imageSize;
      int filterrowoffset = filterOffset + (m + halfFilterSize) * filterSize + halfFilterSize;
      int n = minn;
      while (n <= maxn) {
        int x = col + n;
        sum += images[hook(4, inputimagerowoffset + x)] * filters[hook(5, filterrowoffset + n)];
        n++;
      }
      m++;
    }
    inputPlane++;
  }

  output[hook(6, globalId)] = sum;
}