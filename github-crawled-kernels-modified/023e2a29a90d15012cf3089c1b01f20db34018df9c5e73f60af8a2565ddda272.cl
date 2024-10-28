//{"img_input":0,"img_output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClBinCopy(read_only image2d_t img_input, write_only image2d_t img_output) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  uint4 result = 0;
  uint4 p = read_imageui(img_input, smp, (int2)(coords.x, coords.y));
  write_imageui(img_output, coords, p);
}