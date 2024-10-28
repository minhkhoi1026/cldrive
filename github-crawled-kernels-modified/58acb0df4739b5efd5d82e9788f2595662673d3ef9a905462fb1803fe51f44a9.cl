//{"((__global unsigned int *)(pDst + dstOffsetInBytes))":4,"dstOffsetInBytes":1,"pDst":0,"pPattern":2,"patternSizeInEls":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillBufferMiddle(global uchar* pDst, unsigned int dstOffsetInBytes, const global unsigned int* pPattern, const unsigned int patternSizeInEls) {
  unsigned int gid = get_global_id(0);
  ((global unsigned int*)(pDst + dstOffsetInBytes))[hook(4, gid)] = pPattern[hook(2, gid & (patternSizeInEls - 1))];
}