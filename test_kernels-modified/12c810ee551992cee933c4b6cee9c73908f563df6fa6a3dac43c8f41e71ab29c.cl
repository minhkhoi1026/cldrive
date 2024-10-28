//{"miniBatchSize":5,"paddedArrayBatch":1,"paddedVolume":4,"paddingLookupTable":2,"unpaddedArrayBatch":0,"unpaddedVolume":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ZeroUnpad(global float* unpaddedArrayBatch, global float* paddedArrayBatch, global int* paddingLookupTable, const int unpaddedVolume, const int paddedVolume, const int miniBatchSize) {
  const int iUnpadded = get_global_id(0);

  if (iUnpadded < unpaddedVolume * miniBatchSize) {
    int iExample = iUnpadded / unpaddedVolume;
    int iUnpaddedWithinExample = iUnpadded - unpaddedVolume * iExample;

    int iExampleBeginningInPadded = iExample * paddedVolume;

    int iPadded = iExampleBeginningInPadded + paddingLookupTable[hook(2, iUnpaddedWithinExample)];

    unpaddedArrayBatch[hook(0, iUnpadded)] = paddedArrayBatch[hook(1, iPadded)];
  }
}