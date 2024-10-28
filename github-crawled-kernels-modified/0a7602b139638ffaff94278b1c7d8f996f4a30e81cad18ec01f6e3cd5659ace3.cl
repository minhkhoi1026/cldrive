//{"aBufferIn":0,"aBufferOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void to_gray4(global uchar4* aBufferIn, global uchar4* aBufferOut) {
  int global_id = get_global_id(0);
  uchar gray = aBufferIn[hook(0, global_id)].x * 0.299 + aBufferIn[hook(0, global_id)].y * 0.587 + aBufferIn[hook(0, global_id)].z * 0.114;
  aBufferOut[hook(1, global_id)] = (uchar4)(gray, gray, gray, aBufferIn[hook(0, global_id)].w);
}