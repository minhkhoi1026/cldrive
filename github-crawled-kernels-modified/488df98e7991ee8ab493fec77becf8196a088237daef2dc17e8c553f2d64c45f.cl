//{"bytesToRead":4,"dstOffsetInUInts":3,"pByteDst":5,"pByteSrc":6,"pDst":1,"pSrc":0,"srcOffsetInUInts":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferUInts(const global unsigned int* pSrc, global unsigned int* pDst, unsigned int srcOffsetInUInts, unsigned int dstOffsetInUInts, unsigned int bytesToRead) {
  unsigned int index = get_global_id(0);

  pSrc += srcOffsetInUInts + index;
  pDst += dstOffsetInUInts + index;

  unsigned int lastIndex = bytesToRead / sizeof(unsigned int);

  if (index < lastIndex) {
    pDst[hook(1, 0)] = pSrc[hook(0, 0)];
  } else {
    if (index == lastIndex) {
      const global uchar* pByteSrc = pSrc;
      global uchar* pByteDst = pDst;

      unsigned int bytesRemaining = bytesToRead % sizeof(unsigned int);

      while (bytesRemaining) {
        pByteDst[hook(5, 0)] = pByteSrc[hook(6, 0)];

        bytesRemaining--;
        pByteSrc++;
        pByteDst++;
      }
    }
  }
}