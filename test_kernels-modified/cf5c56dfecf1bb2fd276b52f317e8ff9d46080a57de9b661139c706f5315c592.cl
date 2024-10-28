//{"dst":2,"dst_offset":3,"first_mask":5,"last_mask":6,"size":4,"src":0,"src_offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_copy_region_unalign_same_offset(global int* src, unsigned int src_offset, global int* dst, unsigned int dst_offset, unsigned int size, unsigned int first_mask, unsigned int last_mask) {
  int i = get_global_id(0);
  if (i > size - 1)
    return;

  if (i == 0) {
    dst[hook(2, dst_offset)] = (dst[hook(2, dst_offset)] & first_mask) | (src[hook(0, src_offset)] & (~first_mask));
  } else if (i == size - 1) {
    dst[hook(2, i + dst_offset)] = (src[hook(0, i + src_offset)] & last_mask) | (dst[hook(2, i + dst_offset)] & (~last_mask));
  } else {
    dst[hook(2, i + dst_offset)] = src[hook(0, i + src_offset)];
  }
}