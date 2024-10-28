//{"filterSize":3,"inputWidth":1,"outputWidth":2,"recFieldLookupTable":0,"receptiveFieldSize":4,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CreateRecFieldsLookupTable(global int* recFieldLookupTable, const int inputWidth, const int outputWidth, const int filterSize, const int receptiveFieldSize, const int stride) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  const int nReceptiveFields = outputWidth * outputWidth;

  if (i < receptiveFieldSize && j < nReceptiveFields) {
    const int iReceptiveFieldElement = i;
    const int iReceptiveField = j;

    int iInput = 0;
    const int iOutput = iReceptiveFieldElement * nReceptiveFields + iReceptiveField;

    const int iChannel = i / (filterSize * filterSize);
    const int elementsPerChannel = inputWidth * inputWidth;
    const int iBeginningOfChannel = elementsPerChannel * iChannel;

    iInput += iBeginningOfChannel;

    const int iOutputRow = j / outputWidth;
    const int iOutputCol = j % outputWidth;
    const int iBeginningOfReceptiveField = iOutputRow * stride * inputWidth + stride * iOutputCol;

    iInput += iBeginningOfReceptiveField;

    const int iFilterRow = (i % (filterSize * filterSize)) / filterSize;
    const int iReceptiveFieldCol = i % filterSize;
    const int iWithinReceptiveField = inputWidth * iFilterRow + iReceptiveFieldCol;

    iInput += iWithinReceptiveField;

    recFieldLookupTable[hook(0, iOutput)] = iInput;
  }
}