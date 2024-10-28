//{"inputBatch":1,"miniBatchSize":5,"paddedInputBatch":0,"paddedVolume":4,"paddingLookupTable":2,"unpaddedVolume":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ZeroPad(global float* paddedInputBatch, global float* inputBatch, global int* paddingLookupTable, const int unpaddedVolume, const int paddedVolume, const int miniBatchSize) {
  const int iUnpadded = get_global_id(0);

  if (iUnpadded < unpaddedVolume * miniBatchSize) {
    int iExample = iUnpadded / unpaddedVolume;
    int iUnpaddedWithinExample = iUnpadded - unpaddedVolume * iExample;

    int iExampleBeginningInPadded = iExample * paddedVolume;

    int iPadded = iExampleBeginningInPadded + paddingLookupTable[hook(2, iUnpaddedWithinExample)];

    paddedInputBatch[hook(0, iPadded)] = inputBatch[hook(1, iUnpadded)];
  }
}