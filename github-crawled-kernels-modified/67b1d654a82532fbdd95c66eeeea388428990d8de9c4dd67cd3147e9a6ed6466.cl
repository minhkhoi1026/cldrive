//{"fgmap":1,"input":0,"labels":2,"visual":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void copy_red_tint(read_only image2d_t input, read_only image2d_t fgmap, global int* labels, write_only image2d_t visual, int width) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  int adr = (int2)(pos.x + 1, pos.y + 1).x + (int2)(pos.x + 1, pos.y + 1).y * (width + 2);

  uint4 input_pxl = read_imageui(input, sampler, pos);
  uint4 fgmap_pxl = read_imageui(fgmap, sampler, pos);
  uint4 out_pxl = (uint4)(255, input_pxl.s1, input_pxl.s2, 255);

  if (fgmap_pxl.s0 != 0) {
    out_pxl.s0 = input_pxl.s0;
  }

  barrier(0x02);

  write_imageui(visual, pos, out_pxl);
}