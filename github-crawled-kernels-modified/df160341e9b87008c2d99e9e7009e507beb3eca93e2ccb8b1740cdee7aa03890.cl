//{"output":1,"update_mask":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
int read_val(read_only image2d_t input, int x, int y) {
  int2 pos = (int2)(x, y);
  uint4 pixel = read_imageui(input, sampler, pos);
  return pixel.s0;
}

kernel void update_foreground(read_only image2d_t update_mask, write_only image2d_t output) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  uint4 mask_pxl = read_imageui(update_mask, sampler, pos);
  if (mask_pxl.s0 == 255) {
    write_imageui(output, pos, 0);
  } else if (mask_pxl.s1 == 255) {
    write_imageui(output, pos, 255);
  }
}