//{"dst":1,"dst_offset":6,"dst_row_pitch":9,"dst_slice_pitch":10,"region0":2,"region1":3,"region2":4,"src":0,"src_offset":5,"src_row_pitch":7,"src_slice_pitch":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_copy_buffer_rect(global char* src, global char* dst, unsigned int region0, unsigned int region1, unsigned int region2, unsigned int src_offset, unsigned int dst_offset, unsigned int src_row_pitch, unsigned int src_slice_pitch, unsigned int dst_row_pitch, unsigned int dst_slice_pitch) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);
  if ((i >= region0) || (j >= region1) || (k >= region2))
    return;
  src_offset += k * src_slice_pitch + j * src_row_pitch + i;
  dst_offset += k * dst_slice_pitch + j * dst_row_pitch + i;
  dst[hook(1, dst_offset)] = src[hook(0, src_offset)];
}