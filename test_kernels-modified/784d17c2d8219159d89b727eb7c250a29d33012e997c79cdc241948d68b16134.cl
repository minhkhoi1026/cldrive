//{"dstSshOffset":3,"len":2,"pDst":0,"pDstWithOffset":5,"pSrc":1,"pSrcWithOffset":6,"srcSshOffset":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferToBufferSideRegion(global uchar* pDst, const global uchar* pSrc, unsigned int len, unsigned int dstSshOffset, unsigned int srcSshOffset) {
  unsigned int gid = get_global_id(0);
  global uchar* pDstWithOffset = (global uchar*)((global uchar*)pDst + dstSshOffset);
  global uchar* pSrcWithOffset = (global uchar*)((global uchar*)pSrc + srcSshOffset);
  if (gid < len) {
    pDstWithOffset[hook(5, gid)] = pSrcWithOffset[hook(6, gid)];
  }
}