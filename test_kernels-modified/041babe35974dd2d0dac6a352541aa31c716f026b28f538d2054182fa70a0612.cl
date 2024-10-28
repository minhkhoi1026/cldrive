//{"dst":2,"dst_offset":3,"dw_mask":8,"first_mask":5,"last_mask":6,"shift":7,"size":4,"src":0,"src_less":9,"src_offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_copy_region_unalign_src_offset(global int* src, unsigned int src_offset, global int* dst, unsigned int dst_offset, unsigned int size, unsigned int first_mask, unsigned int last_mask, unsigned int shift, unsigned int dw_mask, int src_less) {
  int i = get_global_id(0);
  unsigned int tmp = 0;

  if (i > size - 1)
    return;

  if (i == 0) {
    tmp = ((src[hook(0, src_offset + i)] & dw_mask) << shift);
  } else if (src_less && i == size - 1) {
    tmp = ((src[hook(0, src_offset + i - 1)] & ~dw_mask) >> (32 - shift));
  } else {
    tmp = ((src[hook(0, src_offset + i - 1)] & ~dw_mask) >> (32 - shift)) | ((src[hook(0, src_offset + i)] & dw_mask) << shift);
  }

  if (i == 0) {
    dst[hook(2, dst_offset)] = (dst[hook(2, dst_offset)] & first_mask) | (tmp & (~first_mask));
  } else if (i == size - 1) {
    dst[hook(2, i + dst_offset)] = (tmp & last_mask) | (dst[hook(2, i + dst_offset)] & (~last_mask));
  } else {
    dst[hook(2, i + dst_offset)] = tmp;
  }
}