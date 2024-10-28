//{"bytesToRead":4,"dstOffsetInBytes":3,"pDst":1,"pSrc":0,"srcOffsetInBytes":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferBytes(const global uchar* pSrc, global uchar* pDst, unsigned int srcOffsetInBytes, unsigned int dstOffsetInBytes, unsigned int bytesToRead) {
  unsigned int index = get_global_id(0);

  pSrc += (srcOffsetInBytes + index);
  pDst += (dstOffsetInBytes + index);

  unsigned int lastIndex = bytesToRead / sizeof(uchar);

  if (index < lastIndex) {
    pDst[hook(1, 0)] = pSrc[hook(0, 0)];
  }
}