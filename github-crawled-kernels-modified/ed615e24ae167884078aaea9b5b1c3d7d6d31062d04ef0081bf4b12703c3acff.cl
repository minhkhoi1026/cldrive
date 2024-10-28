//{"image1":0,"image2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_1D_buffer(read_only image1d_buffer_t image1, write_only image1d_buffer_t image2) {
  int x = get_global_id(0);

  uint4 float3 = read_imageui(image1, x);
  write_imageui(image2, x, float3);
}