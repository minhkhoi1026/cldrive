//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 4 | 0x10;
kernel void Image3DCopy(read_only image3d_t input, write_only image2d_t output) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  uint4 temp0 = read_imageui(input, imageSampler, (int4)(coord, 0, 0));

  uint4 temp1 = read_imageui(input, imageSampler, (int4)((int2)(get_global_id(0), get_global_id(1) - get_global_size(1) / 2), 1, 0));

  write_imageui(output, coord, temp0 + temp1);
}