//{"fb":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(write_only image2d_t fb) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int w = get_image_width(fb);
  int h = get_image_height(fb);

  if (x < w && y < h) {
    write_imagef(fb, (int2)(x, y), (float4)(x / (float)w, y / (float)h, 0.0f, 1.0f));
  }
}