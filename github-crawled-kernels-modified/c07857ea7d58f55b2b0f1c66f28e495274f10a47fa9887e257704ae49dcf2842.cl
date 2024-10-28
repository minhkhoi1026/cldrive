//{"input":1,"inputArea":3,"inputVolume":2,"miniBatchSize":5,"nFeatureMaps":4,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AveragePoolingForward(global float* output, global float* input, const int inputVolume, const int inputArea, const int nFeatureMaps, const int miniBatchSize) {
  const int iExample = get_global_id(0);
  const int iFeatureMap = get_global_id(1);

  if (iExample < miniBatchSize && iFeatureMap < nFeatureMaps) {
    const int iExampleBeginning = iExample * inputVolume;
    const int iMapBeginning = iFeatureMap * inputArea;

    const int iBeginning = iExampleBeginning + iMapBeginning;

    float average = 0.0F;

    for (int iWithinMap = 0; iWithinMap < inputArea; iWithinMap++) {
      average += input[hook(1, iBeginning + iWithinMap)];
    }
    average /= inputArea;

    int iOutputActivation = iExample * nFeatureMaps + iFeatureMap;
    output[hook(0, iOutputActivation)] = average;
  }
}