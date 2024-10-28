//{"filterSize":3,"filters":5,"images":4,"inputImageSize":2,"numFilters":1,"numInputPlanes":0,"output":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve_imagecubes_float_nopadzeros(const int numInputPlanes, const int numFilters, const int inputImageSize, const int filterSize, global const float* images, global const float* filters, global float* output) {
  int globalId = get_global_id(0);

  int inputImageSizeSquared = inputImageSize * inputImageSize;
  int outputImageSize = inputImageSize - filterSize + 1;
  int outputImageSizeSquared = outputImageSize * outputImageSize;

  int outputImage2Id = globalId / outputImageSizeSquared;
  int filterId = outputImage2Id % numFilters;
  int inputImage3Id = outputImage2Id / numFilters;

  int filterOffset = filterId * filterSize * filterSize;
  int inputImage3Offset = inputImage3Id * numInputPlanes * inputImageSizeSquared;

  int localid = globalId % outputImageSizeSquared;
  int outputRow = localid / outputImageSize;
  int outputCol = localid % outputImageSize;

  int halfFilterSize = filterSize >> 1;
  float sum = 0;
  int minm = -halfFilterSize;
  int maxm = halfFilterSize;
  int minn = -halfFilterSize;
  int maxn = halfFilterSize;
  int inputPlane = 0;
  while (inputPlane < numInputPlanes) {
    int inputImageOffset = inputImage3Offset + inputPlane * inputImageSizeSquared;
    int m = minm;
    while (m <= maxm) {
      int inputRow = outputRow + m + halfFilterSize;
      int inputimagerowoffset = inputImageOffset + inputRow * inputImageSize;
      int filterrowoffset = filterOffset + (m + halfFilterSize) * filterSize + halfFilterSize;
      int n = minn;
      while (n <= maxn) {
        int inputCol = outputCol + n + halfFilterSize;
        sum += images[hook(4, inputimagerowoffset + inputCol)] * filters[hook(5, filterrowoffset + n)];
        n++;
      }
      m++;
    }
    inputPlane++;
  }
  output[hook(6, globalId)] = sum;
}