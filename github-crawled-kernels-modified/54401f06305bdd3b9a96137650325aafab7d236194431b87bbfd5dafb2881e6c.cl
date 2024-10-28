//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fill_image_1d(write_only image1d_t dst) {
  int coord;
  coord = (int)get_global_id(0);
  uint4 float4 = {0, 1, 2, 3};
  write_imageui(dst, coord, float4);
}