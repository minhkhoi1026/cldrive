//{"dstSshOffset":3,"elems":2,"pDst":0,"pSrc":1,"srcSshOffset":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferToBufferMiddleRegion(global unsigned int* pDst, const global unsigned int* pSrc, unsigned int elems, unsigned int dstSshOffset, unsigned int srcSshOffset) {
  unsigned int gid = get_global_id(0);
  global unsigned int* pDstWithOffset = (global unsigned int*)((global uchar*)pDst + dstSshOffset);
  global unsigned int* pSrcWithOffset = (global unsigned int*)((global uchar*)pSrc + srcSshOffset);
  if (gid < elems) {
    uint4 loaded = vload4(gid, pSrcWithOffset);
    vstore4(loaded, gid, pDstWithOffset);
  }
}