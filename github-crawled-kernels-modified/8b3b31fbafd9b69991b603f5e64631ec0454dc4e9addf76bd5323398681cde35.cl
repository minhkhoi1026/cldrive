//{"dst_image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_with_black(write_only image2d_t dst_image) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  write_imagef(dst_image, coords, (float4)(0, 0, 0, 0));
}