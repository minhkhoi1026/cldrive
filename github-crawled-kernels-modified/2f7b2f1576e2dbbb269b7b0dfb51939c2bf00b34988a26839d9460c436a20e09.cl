//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 4 | 0x10;
kernel void Image2DCopy(read_only image2d_t input, write_only image2d_t output) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  uint4 temp = read_imageui(input, imageSampler, coord);

  write_imageui(output, coord, temp);
}