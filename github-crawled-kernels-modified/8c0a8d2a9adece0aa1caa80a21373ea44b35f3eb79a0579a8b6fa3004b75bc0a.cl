//{"deltaXbatch":0,"deltaYbatch":1,"dropoutMask":3,"miniBatchSize":6,"nInputUnits":4,"nOutputUnits":5,"weights":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FCBackward(global float* deltaXbatch, global float* deltaYbatch, global float* weights, global bool* dropoutMask, const int nInputUnits, const int nOutputUnits, const int miniBatchSize) {
  const int iInputUnit = get_global_id(0);
  const int iMiniBatchItem = get_global_id(1);

  if (iInputUnit < nInputUnits && iMiniBatchItem < miniBatchSize) {
    int iMiniBatchStart = iMiniBatchItem * nOutputUnits;
    int iOutputActivation = 0;
    float sum = 0.0F;

    for (int iOutputUnit = 0; iOutputUnit < nOutputUnits; iOutputUnit++) {
      iOutputActivation = iMiniBatchStart + iOutputUnit;

      if (dropoutMask[hook(3, iOutputActivation)] == true) {
        sum += weights[hook(2, iOutputUnit * nInputUnits + iInputUnit)] * deltaYbatch[hook(1, iOutputActivation)];
      }
    }

    deltaXbatch[hook(0, iMiniBatchItem * nInputUnits + iInputUnit)] = sum;
  }
}