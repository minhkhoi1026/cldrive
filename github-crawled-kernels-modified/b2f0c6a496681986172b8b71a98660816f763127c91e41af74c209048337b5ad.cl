//{"deltaBeta":6,"deltaGamma":5,"deltaInput":0,"deltaOutput":1,"gamma":3,"inputArea":7,"inputVolume":8,"miniBatchSize":9,"normalizedInput":2,"variance":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNConvBackPropagate(global float* deltaInput, global float* deltaOutput, global float* normalizedInput, constant float* gamma, constant float* variance, constant float* deltaGamma, constant float* deltaBeta, const int inputArea, const int inputVolume, const int miniBatchSize) {
  const int iActivation = get_global_id(0);

  if (iActivation < inputVolume * miniBatchSize) {
    int iFeatureMap = (iActivation % inputVolume) / inputArea;
    int iMapBeginning = iFeatureMap * inputArea;
    int iWithinMap = iActivation % inputArea;

    float tmpDeltaX = 0.0F;

    tmpDeltaX = deltaOutput[hook(1, iActivation)] - deltaBeta[hook(6, iMapBeginning + iWithinMap)] / inputArea - deltaGamma[hook(5, iFeatureMap)] * normalizedInput[hook(2, iActivation)] / inputArea;
    tmpDeltaX *= (gamma[hook(3, iFeatureMap)] * native_rsqrt(variance[hook(4, iFeatureMap)] + 1.0E-5));

    deltaInput[hook(0, iActivation)] = tmpDeltaX;
  }
}