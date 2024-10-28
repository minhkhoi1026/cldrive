//{"image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void write_uint(write_only image2d_array_t image) {
  write_imageui(image, (int4)(0), (uint4)(0));
}