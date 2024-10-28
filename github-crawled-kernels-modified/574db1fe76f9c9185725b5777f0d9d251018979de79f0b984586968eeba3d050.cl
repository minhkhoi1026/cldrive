//{"border":6,"crop_h":5,"crop_w":4,"crop_x":2,"crop_y":3,"img_uv":1,"img_y":0,"u":8,"v":9,"y":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void wireframe(write_only image2d_t img_y, write_only image2d_t img_uv, unsigned int crop_x, unsigned int crop_y, unsigned int crop_w, unsigned int crop_h, unsigned int border, uchar y, uchar u, uchar v) {
  sampler_t sampler = 0 | 2 | 0x10;
  size_t g_id_x = get_global_id(0);
  size_t g_id_y = get_global_id(1);
  uint4 Y = (uint4)y;
  uint4 UV = (uint4)(u, v, 0, 0);

  if ((g_id_x < crop_w && g_id_y < border) || ((g_id_x < border || (g_id_x + border >= crop_w && g_id_x < crop_w)) && (g_id_y >= border && g_id_y + border < crop_h)) || (g_id_x < crop_w && (g_id_y + border >= crop_h && g_id_y < crop_h))) {
    write_imageui(img_y, (int2)(g_id_x + crop_x, 2 * (g_id_y + crop_y)), Y);
    write_imageui(img_y, (int2)(g_id_x + crop_x, 2 * (g_id_y + crop_y) + 1), Y);
    write_imageui(img_uv, (int2)(g_id_x + crop_x, g_id_y + crop_y), UV);
  }
}