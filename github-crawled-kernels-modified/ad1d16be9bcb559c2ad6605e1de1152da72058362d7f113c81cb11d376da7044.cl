//{"cumulativeMeans":2,"cumulativeVariances":3,"iCumulativeAverage":8,"input":4,"isPreInference":7,"means":0,"miniBatchSize":6,"nUnits":5,"variances":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNFCComputeMeansVariances(global float* means, global float* variances, global float* cumulativeMeans, global float* cumulativeVariances, global float* input, const int nUnits, const int miniBatchSize, const int isPreInference, const int iCumulativeAverage) {
  const int iUnit = get_global_id(0);

  if (iUnit < nUnits) {
    float mean = 0.0F;

    for (int iExample = 0; iExample < miniBatchSize; iExample++) {
      mean += input[hook(4, iUnit + iExample * nUnits)];
    }
    mean /= miniBatchSize;

    means[hook(0, iUnit)] = mean;

    if (isPreInference > 0) {
      cumulativeMeans[hook(2, iUnit)] = (iCumulativeAverage * cumulativeMeans[hook(2, iUnit)] + mean) / (iCumulativeAverage + 1);
    }

    float centeredInput = 0.0F;
    float variance = 0.0F;

    for (int iExample = 0; iExample < miniBatchSize; iExample++) {
      centeredInput = input[hook(4, iUnit + iExample * nUnits)] - mean;
      variance += (centeredInput * centeredInput);
    }
    variance /= miniBatchSize;

    variances[hook(1, iUnit)] = variance;

    if (isPreInference > 0) {
      cumulativeVariances[hook(3, iUnit)] = (iCumulativeAverage * cumulativeVariances[hook(3, iUnit)] + variance) / (iCumulativeAverage + 1);
    }
  }
}