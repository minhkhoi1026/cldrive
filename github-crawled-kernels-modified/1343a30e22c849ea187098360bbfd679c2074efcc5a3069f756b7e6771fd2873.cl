//{"dst":2,"dst_offset":3,"size":4,"src":0,"src_offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_cpy_region_align1(global char* src, unsigned int src_offset, global char* dst, unsigned int dst_offset, unsigned int size) {
  int i = get_global_id(0);
  if (i < size)
    dst[hook(2, i + dst_offset)] = src[hook(0, i + src_offset)];
}