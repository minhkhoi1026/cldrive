//{"dst":1,"dst_pad":4,"elem_size":2,"src":0,"src_pad":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_interleave_naive(global char* src, global char* dst, int elem_size, int src_pad, int dst_pad) {
  int gid = get_global_id(0);
  for (int i = 0; i < elem_size; ++i) {
    dst[hook(1, gid * elem_size * dst_pad + i)] = src[hook(0, gid * elem_size * src_pad + i)];
  }
}