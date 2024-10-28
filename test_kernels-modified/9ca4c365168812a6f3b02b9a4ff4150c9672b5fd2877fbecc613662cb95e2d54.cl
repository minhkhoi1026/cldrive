//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copyBufferToBufferBytesSingle(global uchar* dst, const global uchar* src) {
  unsigned int gid = get_global_id(0);
  dst[hook(0, gid)] = (uchar)(src[hook(1, gid)]);
}