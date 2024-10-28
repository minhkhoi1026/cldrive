//{"dstSshOffset":1,"pDst":4,"pPattern":2,"pSrc":5,"patternSshOffset":3,"ptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillBufferSSHOffset(global uchar* ptr, unsigned int dstSshOffset, const global uchar* pPattern, unsigned int patternSshOffset) {
  unsigned int dstIndex = get_global_id(0);
  unsigned int srcIndex = get_local_id(0);
  global uchar* pDst = (global uchar*)ptr + dstSshOffset;
  global uchar* pSrc = (global uchar*)pPattern + patternSshOffset;
  pDst[hook(4, dstIndex)] = pSrc[hook(5, srcIndex)];
}