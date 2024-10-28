//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fill_image_1d_array(write_only image1d_array_t dst) {
  int coordx;
  int coordy;
  coordx = (int)get_global_id(0);
  coordy = (int)get_global_id(1);
  uint4 float4 = {0, 1, 2, 3};
  if (coordy < 7)
    write_imageui(dst, (int2)(coordx, coordy), float4);
}