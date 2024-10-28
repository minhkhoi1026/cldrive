//{"firstThetaBiasIndex":3,"inMatrix":0,"inWidth":4,"outMatrix":2,"thetaMatrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void forwardPropagation(global double* inMatrix, global double* thetaMatrix, global double* outMatrix, int firstThetaBiasIndex, int inWidth) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int thetaWidth = get_global_size(0);
  double sum = 0.0f;
  for (int k = 0; k < inWidth; k++) {
    sum += inMatrix[hook(0, j * inWidth + k)] * thetaMatrix[hook(1, k * thetaWidth + i)];
  }
  sum += thetaMatrix[hook(1, firstThetaBiasIndex + i)];
  outMatrix[hook(2, j * thetaWidth + i)] = 1.0f / (1.0f + exp(-sum));
}