//{"img":6,"mask":7,"out":5,"outDims":4,"w":2,"wDims":3,"x":0,"xDims":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_forward_valid(global float* x, constant int* xDims, constant float* w, constant int* wDims, constant int* outDims, global float* out) {
  const int id = get_global_id(0);
  const int size = get_local_size(0);
  const int localId = get_local_id(0);

  const int imgId = id / size;
  const int imgRows = xDims[hook(1, 1)];
  const int imgCols = xDims[hook(1, 2)];
  const int imgChannels = xDims[hook(1, 3)];
  const int inImgPixels = imgRows * imgCols;
  const int inImgSize = imgRows * imgCols * imgChannels;
  const int inImgPtr = imgId * inImgSize;

  const int maskRows = wDims[hook(3, 0)];
  const int maskCols = wDims[hook(3, 1)];
  const int maskChannels = wDims[hook(3, 2)];
  const int maskFeatures = wDims[hook(3, 3)];
  const int maskPixelInfo = maskChannels * maskFeatures;
  const int channelMaskSize = maskRows * maskCols * maskFeatures;
  const int maskSize = channelMaskSize * maskChannels;

  const int outRows = outDims[hook(4, 1)];
  const int outCols = outDims[hook(4, 2)];
  const int outFeatures = outDims[hook(4, 3)];
  const int outImageSize = outRows * outCols * outFeatures;
  const int outImgPtr = imgId * outImageSize;

  local float img[12 * 12];
  local float mask[25 * 64];

  for (int i = localId; i < outImageSize; i += size) {
    out[hook(5, outImgPtr + i)] = 0;
  }

  for (int channelId = 0; channelId < maskChannels; channelId++) {
    for (int i = localId; i < inImgPixels; i += size) {
      img[hook(6, i)] = x[hook(0, inImgPtr + i * imgChannels + channelId)];
    }

    for (int i = localId; i < channelMaskSize; i += size) {
      int featureId = i % maskFeatures;
      int maskPixId = i / maskFeatures;
      mask[hook(7, i)] = w[hook(2, maskPixId * maskPixelInfo + channelId * maskFeatures + featureId)];
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
          result += img[hook(6, inPtr + maskCol)] * mask[hook(7, maskPos)];
          maskPos += maskFeatures;
        }
        inPtr += imgCols;
      }
      out[hook(5, outImgPtr + i)] += result;
    }
    barrier(0x01);
  }

  for (int i = localId; i < outImageSize; i += size) {
    float result = out[hook(5, outImgPtr + i)];
    out[hook(5, outImgPtr + i)] = result > 0 ? result : 0;
  }
}