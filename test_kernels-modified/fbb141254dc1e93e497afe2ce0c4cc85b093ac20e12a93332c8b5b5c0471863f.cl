//{"betaSpeed":1,"deltaBeta":5,"deltaGamma":4,"deltaOutput":2,"gammaSpeed":0,"learningRate":9,"miniBatchSize":7,"momCoeff":8,"nUnits":6,"normalizedInput":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNFCUpdateSpeeds(global float* gammaSpeed, global float* betaSpeed, global float* deltaOutput, global float* normalizedInput, global float* deltaGamma, global float* deltaBeta, const int nUnits, const int miniBatchSize, const float momCoeff, const float learningRate) {
  const int iUnit = get_global_id(0);

  if (iUnit < nUnits) {
    float gammaGrad = 0.0F;
    float betaGrad = 0.0F;
    int iActivation = iUnit;

    for (int iExample = 0; iExample < miniBatchSize; iExample++) {
      gammaGrad += (deltaOutput[hook(2, iActivation)] * normalizedInput[hook(3, iActivation)]);
      betaGrad += deltaOutput[hook(2, iActivation)];

      iActivation += nUnits;
    }

    gammaGrad /= miniBatchSize;
    betaGrad /= miniBatchSize;

    deltaGamma[hook(4, iUnit)] = gammaGrad;

    gammaSpeed[hook(0, iUnit)] = (momCoeff * gammaSpeed[hook(0, iUnit)]) - learningRate * gammaGrad;

    deltaBeta[hook(5, iUnit)] = betaGrad;

    betaSpeed[hook(1, iUnit)] = (momCoeff * betaSpeed[hook(1, iUnit)]) - learningRate * betaGrad;
  }
}