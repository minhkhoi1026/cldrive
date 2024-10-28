//{"acc":4,"crop_h":3,"crop_x":1,"crop_y":2,"img_y":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce_luma(read_only image2d_t img_y, int crop_x, int crop_y, int crop_h, global unsigned int* acc) {
  sampler_t sampler = 0 | 4 | 0x10;
  size_t g_id = crop_x + get_global_id(0);
  uint4 Y = (uint4)(0, 0, 0, 0);

  int i;
  for (i = 0; i < crop_h; i++) {
    Y += read_imageui(img_y, sampler, (int2)(g_id, crop_y + i));
  }

  *((global uint4*)acc + get_global_id(0)) = Y;
}