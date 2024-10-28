//{"betaSpeed":1,"deltaBeta":3,"deltaBetaBatch":5,"deltaGamma":2,"deltaGammaBatch":4,"gammaSpeed":0,"inputArea":7,"inputDepth":6,"learningRate":9,"miniBatchSize":10,"momCoeff":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNConvUpdateSpeeds(global float* gammaSpeed, global float* betaSpeed, global float* deltaGamma, global float* deltaBeta, global float* deltaGammaBatch, global float* deltaBetaBatch, const int inputDepth, const int inputArea, const float momCoeff, const float learningRate, const int miniBatchSize) {
  const int iFeatureMap = get_global_id(0);

  if (iFeatureMap < inputDepth) {
    int iMapBeginning = iFeatureMap * inputArea;
    int iTmpGrad = 0;

    float gammaGrad = 0.0F;
    float betaGrad = 0.0F;

    for (int iWithinMap = 0; iWithinMap < inputArea; iWithinMap++) {
      iTmpGrad = iMapBeginning + iWithinMap;

      gammaGrad += deltaGammaBatch[hook(4, iTmpGrad)];
      betaGrad += deltaBetaBatch[hook(5, iTmpGrad)];
    }

    deltaGamma[hook(2, iFeatureMap)] = gammaGrad;
    deltaBeta[hook(3, iFeatureMap)] = betaGrad;

    gammaSpeed[hook(0, iFeatureMap)] = (momCoeff * gammaSpeed[hook(0, iFeatureMap)]) - learningRate * gammaGrad;
    betaSpeed[hook(1, iFeatureMap)] = (momCoeff * betaSpeed[hook(1, iFeatureMap)]) - learningRate * betaGrad;
  }
}