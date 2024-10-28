//{"beta":3,"deltaX":0,"deltaY":1,"nActivations":4,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void TanhBackward(global float* deltaX, global float* deltaY, global float* y, const float beta, const int nActivations) {
  int iActivation = get_global_id(0);

  if (iActivation < nActivations) {
    deltaX[hook(0, iActivation)] = deltaY[hook(1, iActivation)] * (1 - pown(y[hook(2, iActivation)], 2));
  }
}