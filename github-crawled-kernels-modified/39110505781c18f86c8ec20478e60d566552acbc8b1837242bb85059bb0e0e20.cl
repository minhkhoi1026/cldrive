//{"img":7,"mask":6,"out":5,"outDims":4,"w":2,"wDims":3,"x":0,"xDims":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_forward_3D_1channel(global float* x, constant int* xDims, constant float* w, constant int* wDims, constant int* outDims, global float* out) {
  const int id = get_global_id(0);
  const int size = get_local_size(0);
  const int localId = get_local_id(0);

  const int imgId = id / size;
  const int imgRows = xDims[hook(1, 1)];
  const int imgCols = xDims[hook(1, 2)];
  const int inImgSize = imgRows * imgCols;
  const int inImgPtr = imgId * inImgSize;

  const int maskRows = wDims[hook(3, 0)];
  const int maskCols = wDims[hook(3, 1)];
  const int maskFeatures = wDims[hook(3, 3)];
  const int maskSize = maskRows * maskCols * maskFeatures;

  const int outRows = outDims[hook(4, 1)];
  const int outCols = outDims[hook(4, 2)];
  const int outFeatures = outDims[hook(4, 3)];
  const int outImageSize = outRows * outCols * outFeatures;
  const int outImgPtr = imgId * outImageSize;

  local float img[32 * 32];
  local float mask[32 * 32];

  for (int i = localId; i < maskSize; i += size) {
    mask[hook(6, i)] = w[hook(2, i)];
  }

  for (int i = localId; i < inImgSize; i += size) {
    img[hook(7, i)] = x[hook(0, inImgPtr + i)];
  }
  barrier(0x01);

  for (int i = localId; i < outImageSize; i += size) {
    int outPixel = i / outFeatures;
    int outRow = outPixel / outCols;
    int outCol = outPixel % outCols;
    int outFeature = i % outFeatures;

    int inPtr = outRow * imgCols + outCol;
    float result = 0;
    int maskPos = outFeature;
    for (int maskRow = 0; maskRow < maskRows; maskRow++) {
      for (int maskCol = 0; maskCol < maskRows; maskCol++) {
        result += img[hook(7, inPtr + maskCol)] * mask[hook(6, maskPos)];
        maskPos += maskFeatures;
      }
      inPtr += imgCols;
    }
    out[hook(5, outImgPtr + i)] = result > 0 ? result : 0;
  }
}