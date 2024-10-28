//{"padding":3,"paddingLookupTable":0,"unpaddedDepth":2,"unpaddedWidth":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CreatePaddingLookupTable(global int* paddingLookupTable, const int unpaddedWidth, const int unpaddedDepth, const int padding) {
  const int iUnpadded = get_global_id(0);

  const int unpaddedArea = unpaddedWidth * unpaddedWidth;
  const int unpaddedVolume = unpaddedDepth * unpaddedArea;
  const int nZerosTopRows = padding * (2 * padding + unpaddedWidth);
  const int nZerosPerChannel = 4 * padding * (unpaddedWidth + padding);

  if (iUnpadded < unpaddedVolume) {
    int iPadded = iUnpadded;

    int iChannel = (iUnpadded % unpaddedVolume) / unpaddedArea;

    iPadded += nZerosPerChannel * iChannel;

    int iRow = (iUnpadded % unpaddedArea) / unpaddedWidth;

    iPadded += nZerosTopRows + padding * (2 * iRow + 1);

    paddingLookupTable[hook(0, iUnpadded)] = iPadded;
  }
}