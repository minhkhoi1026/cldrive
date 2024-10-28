//{"dst":1,"dst_pad":3,"src":0,"src_pad":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_interleave_dwords(global unsigned int* src, global unsigned int* dst, int src_pad, int dst_pad) {
  int gid = get_global_id(0);
  dst[hook(1, gid * dst_pad)] = src[hook(0, gid * src_pad)];
}