//{"dstSshOffset":1,"pDst":3,"ptr":0,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void FillBufferImmediate(global uchar* ptr, unsigned int dstSshOffset, const unsigned int value) {
  unsigned int dstIndex = get_global_id(0);
  global uchar* pDst = (global uchar*)ptr + dstSshOffset;
  pDst[hook(3, dstIndex)] = value;
}