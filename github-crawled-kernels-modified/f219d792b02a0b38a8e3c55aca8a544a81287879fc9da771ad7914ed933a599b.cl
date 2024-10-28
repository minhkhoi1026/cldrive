//{"bgmodel":0,"high":5,"input":1,"low":3,"mid":4,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void bgdiff_3thresh(read_only image2d_t bgmodel, read_only image2d_t input, write_only image2d_t output, int low, int mid, int high) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));

  uint4 pixel1 = read_imageui(bgmodel, sampler, pos);
  uint4 pixel2 = read_imageui(input, sampler, pos);

  uint4 diff = abs_diff(pixel1, pixel2);
  unsigned int sum = diff.s0 + diff.s1 + diff.s2;

  uint4 out_pxl = (uint4)(0, 0, 0, 255);
  if (sum > low)
    out_pxl.s0 = 255;
  if (sum > mid)
    out_pxl.s1 = 255;
  if (sum > high)
    out_pxl.s2 = 255;

  write_imageui(output, pos, out_pxl);
}