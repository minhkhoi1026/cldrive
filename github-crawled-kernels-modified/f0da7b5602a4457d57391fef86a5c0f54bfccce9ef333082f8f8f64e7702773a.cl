//{"img_input1":0,"img_input2":1,"img_output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClBinMax(read_only image2d_t img_input1, read_only image2d_t img_input2, write_only image2d_t img_output) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  uint4 p1 = read_imageui(img_input1, smp, (int2)(coords.x, coords.y));
  uint4 p2 = read_imageui(img_input2, smp, (int2)(coords.x, coords.y));
  uint4 result = p1 | p2;
  write_imageui(img_output, coords, result);
}