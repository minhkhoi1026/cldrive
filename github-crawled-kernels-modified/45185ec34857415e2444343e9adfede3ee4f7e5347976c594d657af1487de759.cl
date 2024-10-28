//{"bytesToRead":4,"dstOffsetInUInt4s":3,"pByteDst":5,"pByteSrc":6,"pDst":1,"pSrc":0,"srcOffsetInUInt4s":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferUInt4s(const global uint4* pSrc, global uint4* pDst, unsigned int srcOffsetInUInt4s, unsigned int dstOffsetInUInt4s, unsigned int bytesToRead) {
  unsigned int index = get_global_id(0);

  pSrc += srcOffsetInUInt4s + index;
  pDst += dstOffsetInUInt4s + index;

  unsigned int lastIndex = bytesToRead / sizeof(uint4);

  if (index < lastIndex) {
    pDst[hook(1, 0)] = pSrc[hook(0, 0)];
  } else {
    if (index == lastIndex) {
      const global uchar* pByteSrc = pSrc;
      global uchar* pByteDst = pDst;

      unsigned int bytesRemaining = bytesToRead % sizeof(uint4);

      while (bytesRemaining) {
        pByteDst[hook(5, 0)] = pByteSrc[hook(6, 0)];

        bytesRemaining--;
        pByteSrc++;
        pByteDst++;
      }
    }
  }
}