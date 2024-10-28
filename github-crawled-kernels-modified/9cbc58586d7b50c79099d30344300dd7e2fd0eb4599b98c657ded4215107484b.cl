//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fill_image_2d_array(write_only image2d_array_t dst) {
  int coordx;
  int coordy;
  int coordz;
  coordx = (int)get_global_id(0);
  coordy = (int)get_global_id(1);
  coordz = (int)get_global_id(2);
  uint4 float4 = {0, 1, 2, 3};
  if (coordz < 7)
    write_imageui(dst, (int4)(coordx, coordy, coordz, 0), float4);
}