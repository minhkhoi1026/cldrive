//{"nInputUnits":2,"nOutputUnits":1,"w":0,"weightMaxNorm":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FCConstrainWeightNorm(global float* w, const int nOutputUnits, const int nInputUnits, const float weightMaxNorm) {
  const int iOutputUnit = get_global_id(0);

  if (iOutputUnit < nOutputUnits) {
    float weightVectorNorm = 0.0F;

    for (int iWeightElement = 0; iWeightElement < nInputUnits; iWeightElement++) {
      weightVectorNorm += pow(w[hook(0, iOutputUnit * nInputUnits + iWeightElement)], 2);
    }
    weightVectorNorm = sqrt(weightVectorNorm);

    if (weightVectorNorm > weightMaxNorm) {
      float rescalingFactor = weightMaxNorm / nInputUnits;
      for (int iWeightElement = 0; iWeightElement < nInputUnits; iWeightElement++) {
        w[hook(0, iOutputUnit * nInputUnits + iWeightElement)] *= rescalingFactor;
      }
    }
  }
}