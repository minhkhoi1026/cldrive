//{"dstOffsetInBytes":1,"pDst":0,"pPattern":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillBufferBytes(global uchar* pDst, unsigned int dstOffsetInBytes, const global uchar* pPattern) {
  unsigned int dstIndex = get_global_id(0) + dstOffsetInBytes;
  unsigned int srcIndex = get_local_id(0);
  pDst[hook(0, dstIndex)] = pPattern[hook(2, srcIndex)];
}