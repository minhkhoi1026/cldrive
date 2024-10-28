//{"deltaBetaBatch":1,"deltaGammaBatch":0,"deltaOutput":2,"inputVolume":4,"miniBatchSize":5,"normalizedInput":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNConvParameterGradientsBatch(global float* deltaGammaBatch, global float* deltaBetaBatch, global float* deltaOutput, global float* normalizedInput, const int inputVolume, const int miniBatchSize) {
  const int iUnit = get_global_id(0);

  if (iUnit < inputVolume) {
    float tmpGammaGrad = 0.0F;
    float tmpBetaGrad = 0.0F;

    int iActivation = iUnit;

    for (int iExample = 0; iExample < miniBatchSize; iExample++) {
      tmpGammaGrad += deltaOutput[hook(2, iActivation)] * normalizedInput[hook(3, iActivation)];
      tmpBetaGrad += deltaOutput[hook(2, iActivation)];

      iActivation += inputVolume;
    }

    deltaGammaBatch[hook(0, iUnit)] = tmpGammaGrad;
    deltaBetaBatch[hook(1, iUnit)] = tmpBetaGrad;
  }
}