//{"bytesToRead":4,"dstOffsetInUInt16s":3,"pByteDst":5,"pByteSrc":6,"pDst":1,"pSrc":0,"srcOffsetInUInt16s":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferUInt16s(const global uint16* pSrc, global uint16* pDst, unsigned int srcOffsetInUInt16s, unsigned int dstOffsetInUInt16s, unsigned int bytesToRead) {
  unsigned int index = get_global_id(0);

  pSrc += srcOffsetInUInt16s + index;
  pDst += dstOffsetInUInt16s + index;

  unsigned int lastIndex = bytesToRead / sizeof(uint16);

  if (index < lastIndex) {
    pDst[hook(1, 0)] = pSrc[hook(0, 0)];
  } else {
    if (index == lastIndex) {
      const global uchar* pByteSrc = pSrc;
      global uchar* pByteDst = pDst;

      unsigned int bytesRemaining = bytesToRead % sizeof(uint16);

      while (bytesRemaining) {
        pByteDst[hook(5, 0)] = pByteSrc[hook(6, 0)];

        bytesRemaining--;
        pByteSrc++;
        pByteDst++;
      }
    }
  }
}