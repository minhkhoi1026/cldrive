//{"beta":6,"gamma":5,"input":2,"means":3,"miniBatchSize":8,"nUnits":7,"normalizedInput":1,"output":0,"variances":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNFCForward(global float* output, global float* normalizedInput, global float* input, constant float* means, constant float* variances, constant float* gamma, constant float* beta, const int nUnits, const int miniBatchSize) {
  const int iActivation = get_global_id(0);

  if (iActivation < nUnits * miniBatchSize) {
    int iUnit = iActivation % nUnits;

    float tmpNormalizedInput = (input[hook(2, iActivation)] - means[hook(3, iUnit)]) * native_rsqrt(variances[hook(4, iUnit)] + 1.0E-5);
    normalizedInput[hook(1, iActivation)] = tmpNormalizedInput;

    output[hook(0, iActivation)] = gamma[hook(5, iUnit)] * tmpNormalizedInput + beta[hook(6, iUnit)];
  }
}