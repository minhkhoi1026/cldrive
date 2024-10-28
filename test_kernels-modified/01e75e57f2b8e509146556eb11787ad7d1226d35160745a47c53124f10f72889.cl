//{"dst":2,"dst_offset":3,"size":4,"src":0,"src_offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_cpy_region_align16(global float* src, unsigned int src_offset, global float* dst, unsigned int dst_offset, unsigned int size) {
  int i = get_global_id(0) * 4;
  if (i < size * 4) {
    dst[hook(2, i + dst_offset)] = src[hook(0, i + src_offset)];
    dst[hook(2, i + dst_offset + 1)] = src[hook(0, i + src_offset + 1)];
    dst[hook(2, i + dst_offset + 2)] = src[hook(0, i + src_offset + 2)];
    dst[hook(2, i + dst_offset + 3)] = src[hook(0, i + src_offset + 3)];
  }
}