//{"dstOffsetInBytes":3,"pDst":1,"pSrc":0,"srcOffsetInBytes":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferToBufferMiddle(const global unsigned int* pSrc, global unsigned int* pDst, unsigned int srcOffsetInBytes, unsigned int dstOffsetInBytes) {
  unsigned int gid = get_global_id(0);
  pDst += dstOffsetInBytes >> 2;
  pSrc += srcOffsetInBytes >> 2;
  uint4 loaded = vload4(gid, pSrc);
  vstore4(loaded, gid, pDst);
}