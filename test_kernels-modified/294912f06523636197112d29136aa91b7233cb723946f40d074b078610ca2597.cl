//{"cumulativeMeans":2,"cumulativeVariances":3,"iCumulativeAverage":10,"input":4,"inputArea":6,"inputDepth":5,"inputVolume":7,"isPreInference":9,"means":0,"miniBatchSize":8,"variances":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNConvComputeMeansVariances(global float* means, global float* variances, global float* cumulativeMeans, global float* cumulativeVariances, global float* input, const int inputDepth, const int inputArea, const int inputVolume, const int miniBatchSize, const int isPreInference, const int iCumulativeAverage) {
  const int iFeatureMap = get_global_id(0);

  if (iFeatureMap < inputDepth) {
    int iMapBeginning = iFeatureMap * inputArea;

    float mean = 0.0f;
    float variance = 0.0f;

    for (int iExample = 0; iExample < miniBatchSize; iExample++) {
      for (int iWithinMap = 0; iWithinMap < inputArea; iWithinMap++) {
        mean += input[hook(4, iMapBeginning + iWithinMap)];
      }

      iMapBeginning += inputVolume;
    }
    mean /= (miniBatchSize * inputArea);

    means[hook(0, iFeatureMap)] = mean;

    if (isPreInference > 0) {
      cumulativeMeans[hook(2, iFeatureMap)] = (iCumulativeAverage * cumulativeMeans[hook(2, iFeatureMap)] + mean) / (iCumulativeAverage + 1);
    }

    float centeredInput = 0.0f;

    iMapBeginning = iFeatureMap * inputArea;

    for (int iExample = 0; iExample < miniBatchSize; iExample++) {
      for (int iWithinMap = 0; iWithinMap < inputArea; iWithinMap++) {
        centeredInput = input[hook(4, iMapBeginning + iWithinMap)] - mean;
        variance += centeredInput * centeredInput;
      }
      iMapBeginning += inputVolume;
    }
    variance /= miniBatchSize * inputArea;

    variances[hook(1, iFeatureMap)] = variance;

    if (isPreInference > 0) {
      cumulativeVariances[hook(3, iFeatureMap)] = (iCumulativeAverage * cumulativeVariances[hook(3, iFeatureMap)] + variance) / (iCumulativeAverage + 1);
    }
  }
}