//{"biases":4,"dropoutMask":10,"dropoutParameter":11,"inputBatch":1,"inputVolume":8,"lookupTable":2,"miniBatchSize":9,"nFilters":5,"nReceptiveFields":7,"outputBatch":0,"randomSeed":12,"receptiveFieldSize":6,"weights":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ConvForward(global float* outputBatch, global float* inputBatch, global int* lookupTable, global float* weights, global float* biases, const int nFilters, const int receptiveFieldSize, const int nReceptiveFields, const int inputVolume, const int miniBatchSize, global bool* dropoutMask, const float dropoutParameter, const ulong randomSeed) {
  const int iRow = get_global_id(0);
  const int iReceptiveField = get_global_id(1);

  if (iRow < nFilters * miniBatchSize && iReceptiveField < nReceptiveFields) {
    const int iMiniBatchItem = iRow / nFilters;
    const int iFilter = iRow - nFilters * (iMiniBatchItem);

    const int iOutputMiniBatchItemBeginning = iMiniBatchItem * nFilters * nReceptiveFields;
    const int iOutput = iOutputMiniBatchItemBeginning + iFilter * nReceptiveFields + iReceptiveField;

    const int iInputMiniBatchItemBeginning = iMiniBatchItem * inputVolume;
    const int iFilterRowBeginning = iFilter * receptiveFieldSize;

    float sum = 0.0;
    int iInput = 0;

    bool isUnitOn;
    if (dropoutParameter < 1.0F) {
      ulong thisSeed = randomSeed + iOutput;
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

    dropoutMask[hook(10, iOutput)] = isUnitOn;

    if (isUnitOn) {
      for (int iElement = 0; iElement < receptiveFieldSize; ++iElement) {
        iInput = iInputMiniBatchItemBeginning + lookupTable[hook(2, iElement * nReceptiveFields + iReceptiveField)];

        sum = fma(weights[hook(3, iFilterRowBeginning + iElement)], inputBatch[hook(1, iInput)], sum);
      }

      sum += biases[hook(4, iFilter)];

      outputBatch[hook(0, iOutput)] = sum / dropoutParameter;
    } else {
      outputBatch[hook(0, iOutput)] = 0.0f;
    }
  }
}