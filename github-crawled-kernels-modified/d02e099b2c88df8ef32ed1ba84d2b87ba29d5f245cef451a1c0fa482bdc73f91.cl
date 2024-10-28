//{"dstOffsetInBytes":3,"pDst":1,"pSrc":0,"srcOffsetInBytes":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void CopyBufferToBufferRightLeftover(const global uchar* pSrc, global uchar* pDst, unsigned int srcOffsetInBytes, unsigned int dstOffsetInBytes) {
  unsigned int gid = get_global_id(0);
  pDst[hook(1, gid + dstOffsetInBytes)] = pSrc[hook(0, gid + srcOffsetInBytes)];
}