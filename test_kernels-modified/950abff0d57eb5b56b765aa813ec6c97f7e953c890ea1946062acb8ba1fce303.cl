//{"dst":0,"size":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global uchar* dst, global const uchar* src, const unsigned int size) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  dst[hook(0, gid)] = clamp(src[hook(1, gid)] - 10, 0, 255);
}