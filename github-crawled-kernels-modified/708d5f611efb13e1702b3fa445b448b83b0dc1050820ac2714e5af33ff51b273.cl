//{"buffer":1,"dst_offset":8,"image":0,"region0":2,"region1":3,"region2":4,"src_origin0":5,"src_origin1":6,"src_origin2":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_copy_image_2d_to_buffer_align16(read_only image2d_t image, global uint4* buffer, unsigned int region0, unsigned int region1, unsigned int region2, unsigned int src_origin0, unsigned int src_origin1, unsigned int src_origin2, unsigned int dst_offset) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  if ((i >= region0) || (j >= region1))
    return;
  uint4 float3;
  const sampler_t sampler = 0 | 0 | 0x10;
  int2 src_coord;
  src_coord.x = src_origin0 + i;
  src_coord.y = src_origin1 + j;
  float3 = read_imageui(image, sampler, src_coord);

  *(buffer + dst_offset + region0 * j + i) = float3;
}