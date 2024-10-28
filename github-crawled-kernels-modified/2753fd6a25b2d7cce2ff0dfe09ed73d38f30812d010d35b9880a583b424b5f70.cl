//{"bgdiff":1,"change":0,"update_mask":2}
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

kernel void compute_add_sub_mask(read_only image2d_t change, read_only image2d_t bgdiff, write_only image2d_t update_mask) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  uint4 out_pxl = (uint4)(0, 0, 0, 255);

  uint4 change_pxl = read_imageui(change, sampler, pos);
  if (change_pxl.s0 > 0) {
    out_pxl = (uint4)(255, 0, 0, 255);

    uint4 center = read_imageui(bgdiff, sampler, pos);
    int sum = center.s1;
    if (sum <= 0) {
      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x - 1, pos.y - 1))).s1;
      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x, pos.y - 1))).s1;
      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x + 1, pos.y - 1))).s1;

      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x - 1, pos.y))).s1;
      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x + 1, pos.y))).s1;

      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x - 1, pos.y + 1))).s1;
      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x, pos.y + 1))).s1;
      sum += (uint4)(read_imageui(bgdiff, sampler, (int2)(pos.x + 1, pos.y + 1))).s1;
    }
    if (sum > 0) {
      out_pxl = (uint4)(0, 255, 0, 255);
    }
  }

  barrier(0x02);
  write_imageui(update_mask, pos, out_pxl);
}