//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fill_image0(write_only image2d_t dst) {
  int2 coord;
  coord.x = (int)get_global_id(0);
  coord.y = (int)get_global_id(1);
  int4 float4 = {coord.y & 0xFF, (coord.y & 0xFF00) >> 8, coord.x & 0xFF, (coord.x & 0xFF00) >> 8};
  write_imagei(dst, coord, float4);
}