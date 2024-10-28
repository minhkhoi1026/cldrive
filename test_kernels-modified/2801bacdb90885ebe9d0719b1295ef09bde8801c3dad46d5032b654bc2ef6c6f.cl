//{"deltaBeta":6,"deltaGamma":5,"deltaInput":0,"deltaOutput":1,"gamma":3,"miniBatchSize":8,"nUnits":7,"normalizedInput":2,"variance":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNFCBackPropagate(global float* deltaInput, global float* deltaOutput, global float* normalizedInput, constant float* gamma, constant float* variance, constant float* deltaGamma, constant float* deltaBeta, const int nUnits, const int miniBatchSize) {
  const int iActivation = get_global_id(0);

  if (iActivation < nUnits * miniBatchSize) {
    int iUnit = iActivation % nUnits;

    float tmpDeltaX = 0.0F;

    tmpDeltaX = deltaOutput[hook(1, iActivation)] - deltaBeta[hook(6, iUnit)] - (deltaGamma[hook(5, iUnit)] * normalizedInput[hook(2, iActivation)]);
    tmpDeltaX *= (gamma[hook(3, iUnit)] * native_rsqrt(variance[hook(4, iUnit)] + 1.0E-5));

    deltaInput[hook(0, iActivation)] = tmpDeltaX;
  }
}