//{"image":0,"origin0":5,"origin1":6,"origin2":7,"pattern":1,"region0":2,"region1":3,"region2":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_fill_image_1d_array(write_only image1d_array_t image, float4 pattern, unsigned int region0, unsigned int region1, unsigned int region2, unsigned int origin0, unsigned int origin1, unsigned int origin2) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int k = get_global_id(2);
  int2 coord;
  if ((i >= region0) || (j >= region1) || (k >= region2))
    return;
  coord.x = origin0 + i;
  coord.y = origin2 + k;
  write_imagef(image, coord, pattern);
}