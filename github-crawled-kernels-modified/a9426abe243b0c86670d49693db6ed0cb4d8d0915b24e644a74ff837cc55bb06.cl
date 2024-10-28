//{"out":4,"outDims":3,"poolSize":2,"x":0,"xDims":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void average_pool(global float* x, global int* xDims, int poolSize, global int* outDims, global float* out) {
  const int localId = get_local_id(0);
  const int size = get_local_size(0);

  const int x0 = xDims[hook(1, 0)];
  const int inRows = xDims[hook(1, 1)];
  const int inCols = xDims[hook(1, 2)];
  const int inDepth = xDims[hook(1, 3)];
  const int inRowSize = inCols * inDepth;
  const int inImageSize = inRows * inRowSize;

  const int outImages = xDims[hook(1, 0)];
  const int outRows = outDims[hook(3, 1)];
  const int outCols = outDims[hook(3, 2)];
  const int outDepth = outDims[hook(3, 3)];
  const int outRowSize = outCols * outDepth;
  const int outImageSize = outRows * outRowSize;
  const int outSize = outImages * outImageSize;

  for (int i = localId; i < outSize; i += size) {
    int cellIdx = i % outImageSize;
    int colDepthId = cellIdx % outRowSize;

    int imageId = i / outImageSize;
    int row = cellIdx / outRowSize;
    int col = cellIdx / outDepth % outCols;
    int depth = cellIdx % outDepth;

    int inImgPtr = imageId * inImageSize + row * poolSize * inRowSize + col * poolSize * inDepth + depth;
    float val = 0;
    int rowOffset = 0;
    for (int poolRow = 0; poolRow < poolSize; poolRow++) {
      int colOffset = 0;
      for (int poolCol = 0; poolCol < poolSize; poolCol++) {
        float pos = x[hook(0, inImgPtr + rowOffset + colOffset)];
        val += pos > 0 ? pos : 0;
        colOffset += inDepth;
      }
      rowOffset += inRowSize;
    }
    out[hook(4, i)] = val / (1.0f * poolSize * poolSize);
  }
}