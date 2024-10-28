//{"buffer":1,"dst_origin0":5,"dst_origin1":6,"dst_origin2":7,"image":0,"region0":2,"region1":3,"region2":4,"src_offset":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_copy_buffer_to_image_2d_align16(write_only image2d_t image, global uint4* buffer, unsigned int region0, unsigned int region1, unsigned int region2, unsigned int dst_origin0, unsigned int dst_origin1, unsigned int dst_origin2, unsigned int src_offset) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  uint4 float3 = (uint4)(0);
  int2 dst_coord;
  if ((i >= region0) || (j >= region1))
    return;
  dst_coord.x = dst_origin0 + i;
  dst_coord.y = dst_origin1 + j;
  src_offset += j * region0 + i;
  float3 = buffer[hook(1, src_offset)];
  write_imageui(image, dst_coord, float3);
}