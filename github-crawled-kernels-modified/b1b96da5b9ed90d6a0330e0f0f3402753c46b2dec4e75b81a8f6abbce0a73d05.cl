//{"deltaInput":0,"deltaOutput":1,"inputArea":3,"inputVolume":2,"miniBatchSize":5,"nFeatureMaps":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AveragePoolingBackward(global float* deltaInput, global float* deltaOutput, const int inputVolume, const int inputArea, const int nFeatureMaps, const int miniBatchSize) {
  const int iExample = get_global_id(0);
  const int iUnit = get_global_id(1);

  if (iExample < miniBatchSize && iUnit < inputVolume) {
    int iFeatureMap = iUnit / inputArea;

    float outputGradient = deltaOutput[hook(1, iExample * nFeatureMaps + iFeatureMap)];
    float inputGradient = outputGradient / inputArea;

    int iInputActivation = iExample * inputVolume + iUnit;

    deltaInput[hook(0, iInputActivation)] = inputGradient;
  }
}