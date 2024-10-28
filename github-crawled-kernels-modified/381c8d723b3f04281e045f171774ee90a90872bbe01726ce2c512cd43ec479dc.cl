//{"dest":2,"mask":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void apply_mask(read_only image2d_t src, read_only image2d_t mask, write_only image2d_t dest) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  uint4 src_pxl = read_imageui(src, sampler, pos);
  uint4 mask_pxl = read_imageui(mask, sampler, pos);
  uint4 out_pxl;
  if (mask_pxl.s0 != 0) {
    out_pxl = src_pxl;
  } else {
    out_pxl = (uint4)(0, 0, 0, 255);
  }
  barrier(0x02);
  write_imageui(dest, pos, out_pxl);
}