//{"height":3,"mask":1,"width":2,"work":0}
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

kernel void remove_smallblobs(global int* work, write_only image2d_t mask, int width, int height) {
  int2 pos = (int2)(get_global_id(0) + 1, get_global_id(1) + 1);
  int2 pos_img = (int2)(pos.x - 1, pos.y - 1);
  if (pos.x >= width || pos.y >= height)
    return;

  int adr = pos.x + pos.y * (width + 2);
  int idx = work[hook(0, adr)];
  if (idx > 0) {
    write_imageui(mask, pos_img, 0);
  }
}