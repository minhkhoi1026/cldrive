//{"current":0,"last":1,"output":2,"threshold":3}
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

kernel void abs_diff_thresh(read_only image2d_t current, read_only image2d_t last, write_only image2d_t output, int threshold) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  uint4 current_pxl = read_imageui(current, sampler, pos);
  uint4 last_pxl = read_imageui(last, sampler, pos);
  uint4 diffp = abs_diff(current_pxl, last_pxl);
  unsigned int diffs = (diffp.s0 + diffp.s1 + diffp.s2);
  uint4 out_pxl = 0;
  if (diffs >= threshold) {
    out_pxl = 255;
  }
  barrier(0x01);
  write_imageui(output, pos, out_pxl);
}