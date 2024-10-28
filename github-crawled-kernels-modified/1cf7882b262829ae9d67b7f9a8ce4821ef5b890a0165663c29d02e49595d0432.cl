//{"aBufferIn":0,"aBufferOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void to_gray(global uchar* aBufferIn, global uchar* aBufferOut) {
  int global_id = get_global_id(0);
  int index = global_id * 4;
  uchar r = aBufferIn[hook(0, index)];
  uchar g = aBufferIn[hook(0, index + 1)];
  uchar b = aBufferIn[hook(0, index + 2)];
  uchar gray = 0.299 * r + 0.587 * g + 0.114 * b;
  aBufferOut[hook(1, index)] = gray;
  aBufferOut[hook(1, index + 1)] = gray;
  aBufferOut[hook(1, index + 2)] = gray;
  aBufferOut[hook(1, index + 3)] = aBufferIn[hook(0, index + 3)];
}