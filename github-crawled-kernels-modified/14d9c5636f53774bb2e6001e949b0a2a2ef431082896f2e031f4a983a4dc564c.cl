//{"img_output":0,"x0":1,"xf":3,"y0":2,"yf":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClBinRoi(write_only image2d_t img_output, int x0, int y0, int xf, int yf) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  uint4 result = 0;
  for (int bit = 0; bit < 8; bit++) {
    int i_img = coords.y;
    int j_img = 8 * coords.x + bit;
    unsigned int result_bit = 0;

    if ((i_img >= y0) && (i_img <= yf) && (j_img >= x0) && (j_img <= xf)) {
      result_bit = 1;
    }

    result += result_bit << bit;
  }
  write_imageui(img_output, coords, result);
}