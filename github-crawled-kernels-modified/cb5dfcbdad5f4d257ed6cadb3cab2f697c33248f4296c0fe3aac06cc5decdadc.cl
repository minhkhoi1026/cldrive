//{"input":0,"output":1}
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

kernel void image_dilate8(read_only image2d_t input, write_only image2d_t output) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  unsigned int out_pxl = 0;

  int sum = read_val(input, pos.x, pos.y);

  sum += read_val(input, pos.x - 1, pos.y - 1);
  sum += read_val(input, pos.x, pos.y - 1);
  sum += read_val(input, pos.x + 1, pos.y - 1);

  sum += read_val(input, pos.x - 1, pos.y);
  sum += read_val(input, pos.x + 1, pos.y);

  sum += read_val(input, pos.x - 1, pos.y + 1);
  sum += read_val(input, pos.x, pos.y + 1);
  sum += read_val(input, pos.x + 1, pos.y + 1);

  if (sum > 0) {
    out_pxl = 255;
  }
  write_imageui(output, pos, out_pxl);
}