//{"biases":3,"dropoutMask":9,"dropoutParameter":7,"inputBatch":1,"miniBatchSize":6,"nInputUnits":4,"nOutputUnits":5,"outputBatch":0,"randomSeed":8,"weights":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FCForward(global float* outputBatch, global float* inputBatch, global float* weights, global float* biases, const int nInputUnits, const int nOutputUnits, const int miniBatchSize, const float dropoutParameter, const ulong randomSeed, global bool* dropoutMask) {
  const int iOutputUnit = get_global_id(0);
  const int iMiniBatchItem = get_global_id(1);

  if (iOutputUnit < nOutputUnits && iMiniBatchItem < miniBatchSize) {
    int iOutputActivation = iMiniBatchItem * nOutputUnits + iOutputUnit;

    bool isUnitOn;
    if (dropoutParameter < 1.0F) {
      ulong thisSeed = randomSeed + iOutputActivation;
      thisSeed = (thisSeed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
      unsigned int pseudoRandomInt = thisSeed >> 16;
      for (int j = 0; j < 6; ++j) {
        thisSeed = pseudoRandomInt;
        thisSeed = (thisSeed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
        pseudoRandomInt = thisSeed >> 16;
      }
      float pseudoRandFloat = (float)pseudoRandomInt / (float)4294967295;

      isUnitOn = pseudoRandFloat < dropoutParameter;
    } else {
      isUnitOn = true;
    }

    dropoutMask[hook(9, iOutputActivation)] = isUnitOn;

    if (isUnitOn) {
      int iMiniBatchStart = iMiniBatchItem * nInputUnits;

      float sum = 0.0;

      for (int iInputUnit = 0; iInputUnit < nInputUnits; iInputUnit++) {
        float weightElement = weights[hook(2, iOutputUnit * nInputUnits + iInputUnit)];

        float inputElement = inputBatch[hook(1, iMiniBatchStart + iInputUnit)];

        sum += weightElement * inputElement;
      }

      sum += biases[hook(3, iOutputUnit)];

      outputBatch[hook(0, iOutputActivation)] = sum / dropoutParameter;
    } else {
      outputBatch[hook(0, iOutputActivation)] = 0.0f;
    }
  }
}