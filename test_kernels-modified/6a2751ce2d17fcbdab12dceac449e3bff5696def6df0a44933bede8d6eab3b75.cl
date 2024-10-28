//{"filterSize":2,"gradInput":8,"gradOutput":7,"outImageSize":4,"outNumPlanes":3,"padZeros":5,"upstreamImageSize":1,"upstreamNumPlanes":0,"weights":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calcGradInput(const int upstreamNumPlanes, const int upstreamImageSize, const int filterSize, const int outNumPlanes, const int outImageSize, const int padZeros, global const float* weights, global const float* gradOutput, global float* gradInput) {
  int globalId = get_global_id(0);
  const int halfFilterSize = filterSize >> 1;
  const int margin = padZeros ? halfFilterSize : 0;

  const int upstreamImageSizeSquared = upstreamImageSize * upstreamImageSize;
  const int upstreamImage2dId = globalId / upstreamImageSizeSquared;

  const int intraImageOffset = globalId % upstreamImageSizeSquared;
  const int upstreamRow = intraImageOffset / upstreamImageSize;
  const int upstreamCol = intraImageOffset % upstreamImageSize;

  const int upstreamPlane = upstreamImage2dId % upstreamNumPlanes;
  const int n = upstreamImage2dId / upstreamNumPlanes;

  const int minFilterRow = max(0, upstreamRow + margin - (outImageSize - 1));
  const int maxFilterRow = min(filterSize - 1, upstreamRow + margin);
  const int minFilterCol = max(0, upstreamCol + margin - (outImageSize - 1));
  const int maxFilterCol = min(filterSize - 1, upstreamCol + margin);

  float sumWeightTimesOutError = 0;

  for (int outPlane = 0; outPlane < outNumPlanes; outPlane++) {
    for (int filterRow = minFilterRow; filterRow <= maxFilterRow; filterRow++) {
      int outRow = upstreamRow + margin - filterRow;
      for (int filterCol = minFilterCol; filterCol <= maxFilterCol; filterCol++) {
        int outCol = upstreamCol + margin - filterCol;
        int resultIndex = ((n * outNumPlanes + outPlane) * outImageSize + outRow) * outImageSize + outCol;
        float thisError = gradOutput[hook(7, resultIndex)];
        int thisWeightIndex = ((outPlane * upstreamNumPlanes + upstreamPlane) * filterSize + filterRow) * filterSize + filterCol;
        float thisWeight = weights[hook(6, thisWeightIndex)];
        float thisWeightTimesError = thisWeight * thisError;
        sumWeightTimesOutError += thisWeightTimesError;
      }
    }
  }
  gradInput[hook(8, globalId)] = sumWeightTimesOutError;
}