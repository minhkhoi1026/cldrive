//{"matrixA":3,"matrixPriorDelta":0,"matrixResultDelta":4,"matrixTheta":2,"priorDeltaWidth":5,"useVectorY":6,"vectorY":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculateGradientDelta(global double* matrixPriorDelta, global int* vectorY, global double* matrixTheta, global double* matrixA, global double* matrixResultDelta, int priorDeltaWidth, int useVectorY) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int resultDeltaWidth = get_global_size(1);

  double sum = 0.0f;
  for (int k = 0; k < priorDeltaWidth; k++) {
    double d = matrixPriorDelta[hook(0, i * priorDeltaWidth + k)];
    if (useVectorY != 0 && k == vectorY[hook(1, i)])
      d -= 1.0f;
    sum += d * matrixTheta[hook(2, j * priorDeltaWidth + k)];
  }
  int index = i * resultDeltaWidth + j;
  matrixResultDelta[hook(4, index)] = sum * matrixA[hook(3, index)] * (1 - matrixA[hook(3, index)]);
}