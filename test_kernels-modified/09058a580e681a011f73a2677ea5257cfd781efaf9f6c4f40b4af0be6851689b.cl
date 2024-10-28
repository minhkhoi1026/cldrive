//{"beta":6,"gamma":5,"input":2,"inputArea":7,"inputVolume":8,"means":3,"miniBatchSize":9,"normalizedInput":1,"output":0,"variances":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNConvForward(global float* output, global float* normalizedInput, global float* input, constant float* means, constant float* variances, constant float* gamma, constant float* beta, const int inputArea, const int inputVolume, const int miniBatchSize) {
  const int iActivation = get_global_id(0);

  if (iActivation < inputVolume * miniBatchSize) {
    int iFeatureMap = (iActivation % inputVolume) / inputArea;

    float privateNormalizedInput = (input[hook(2, iActivation)] - means[hook(3, iFeatureMap)]) * native_rsqrt(variances[hook(4, iFeatureMap)] + 1.0E-5);

    normalizedInput[hook(1, iActivation)] = privateNormalizedInput;

    output[hook(0, iActivation)] = gamma[hook(5, iFeatureMap)] * privateNormalizedInput + beta[hook(6, iFeatureMap)];
  }
}