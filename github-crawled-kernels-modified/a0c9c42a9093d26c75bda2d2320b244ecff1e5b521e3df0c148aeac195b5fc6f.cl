//{"fg_map_in":1,"fg_map_out":2,"input":0,"thresh":3,"width":4}
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

kernel void erode_fg_bg_rl(read_only image2d_t input, read_only image2d_t fg_map_in, write_only image2d_t fg_map_out, int thresh, int width) {
  int y = get_global_id(0);

  uint4 last_val = (uint4)(0, 0, 0, 255);

  for (int x = width - 1; x >= 0; x--) {
    int2 pos = (int2)(x, y);
    uint4 pxl_val = read_imageui(fg_map_in, sampler, pos);
    if (pxl_val.s0 > 0) {
      uint4 val = read_imageui(input, sampler, pos);
      uint4 diff4 = abs_diff(val, last_val);
      int diff = diff4.s0 + diff4.s1 + diff4.s2;
      if (diff < thresh) {
        pxl_val = (uint4)(0, 0, 0, 255);
      }
    } else {
      last_val = read_imageui(input, sampler, pos);
    }
    barrier(0x02);
    write_imageui(fg_map_out, pos, pxl_val);
  }
}