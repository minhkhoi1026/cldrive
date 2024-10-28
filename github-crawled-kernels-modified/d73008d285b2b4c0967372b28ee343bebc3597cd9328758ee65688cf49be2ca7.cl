//{"bGradients":3,"bSpeed":1,"deltaYbatch":5,"dropoutMask":6,"inputBatch":4,"learningRate":10,"miniBatchSize":11,"momCoeff":9,"nInputUnits":7,"nOutputUnits":8,"wGradients":2,"wSpeed":0,"weightDecayCoeff":13,"weights":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FCUpdateSpeeds(global float* wSpeed, global float* bSpeed, global float* wGradients, global float* bGradients, global float* inputBatch, global float* deltaYbatch, global bool* dropoutMask, const int nInputUnits, const int nOutputUnits, const float momCoeff, const float learningRate, const int miniBatchSize, global float* weights, const float weightDecayCoeff) {
  const int iOutput = get_global_id(0);
  const int iInput = get_global_id(1);

  if (iOutput < nOutputUnits && iInput < nInputUnits) {
    const int iWeight = iOutput * nInputUnits + iInput;
    const float thisWeightDecay = weightDecayCoeff * weights[hook(12, iWeight)];
    const bool isFirstInputUnit = iInput == 0;

    float gradientWeight = 0.0;
    float gradientBias = 0.0;

    int iOutputElement = 0;

    float deltaYElement = 0.0F;

    for (int iMiniBatchItem = 0; iMiniBatchItem < miniBatchSize; iMiniBatchItem++) {
      iOutputElement = iMiniBatchItem * nOutputUnits + iOutput;

      if (dropoutMask[hook(6, iOutputElement)]) {
        deltaYElement = deltaYbatch[hook(5, iOutputElement)];

        gradientWeight += inputBatch[hook(4, iMiniBatchItem * nInputUnits + iInput)] * deltaYElement + thisWeightDecay;

        if (isFirstInputUnit) {
          gradientBias += deltaYElement;
        }
      }
    }

    wGradients[hook(2, iWeight)] = gradientWeight;

    wSpeed[hook(0, iWeight)] = (momCoeff * wSpeed[hook(0, iWeight)]) - learningRate * gradientWeight;

    if (isFirstInputUnit) {
      bGradients[hook(3, iOutput)] = gradientBias;
      bSpeed[hook(1, iOutput)] = (momCoeff * bSpeed[hook(1, iOutput)]) - learningRate * gradientBias;
    }
  }
}