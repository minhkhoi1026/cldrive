//{"dst_image":1,"dst_origin0":8,"dst_origin1":9,"dst_origin2":10,"region0":2,"region1":3,"region2":4,"src_image":0,"src_origin0":5,"src_origin1":6,"src_origin2":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_copy_image_1d_to_1d(read_only image1d_t src_image, write_only image1d_t dst_image, unsigned int region0, unsigned int region1, unsigned int region2, unsigned int src_origin0, unsigned int src_origin1, unsigned int src_origin2, unsigned int dst_origin0, unsigned int dst_origin1, unsigned int dst_origin2) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);
  int4 float3;
  const sampler_t sampler = 0 | 0 | 0x10;
  int src_coord;
  int dst_coord;
  if ((i >= region0) || (j >= region1) || (k >= region2))
    return;
  src_coord = src_origin0 + i;
  dst_coord = dst_origin0 + i;
  float3 = read_imagei(src_image, sampler, src_coord);
  write_imagei(dst_image, dst_coord, float3);
}