//{"dstOffsetInBytes":1,"pDst":0,"pPattern":2,"patternSizeInEls":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillBufferLeftLeftover(global uchar* pDst, unsigned int dstOffsetInBytes, const global uchar* pPattern, const unsigned int patternSizeInEls) {
  unsigned int gid = get_global_id(0);
  pDst[hook(0, gid + dstOffsetInBytes)] = pPattern[hook(2, gid & (patternSizeInEls - 1))];
}