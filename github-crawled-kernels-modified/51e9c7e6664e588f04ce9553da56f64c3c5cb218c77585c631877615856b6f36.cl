//{"beta":1,"betaSpeed":3,"gamma":0,"gammaSpeed":2,"nGamma":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BNFCUpdateParameters(global float* gamma, global float* beta, constant float* gammaSpeed, constant float* betaSpeed, const int nGamma) {
  int iParameter = get_global_id(0);

  if (iParameter < nGamma) {
    gamma[hook(0, iParameter)] += gammaSpeed[hook(2, iParameter)];
    beta[hook(1, iParameter)] += betaSpeed[hook(3, iParameter)];
  }
}