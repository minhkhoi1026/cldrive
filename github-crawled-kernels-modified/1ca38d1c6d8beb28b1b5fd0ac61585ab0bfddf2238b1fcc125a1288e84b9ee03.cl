//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void image_int(read_only image3d_t input, write_only image2d_t output) {
  int4 pixel = (int4)(get_global_id(0), get_global_id(1), get_global_id(2), 1);
  uint4 value = read_imageui(input, sampler, pixel);
  write_imageui(output, pixel.xy, value);
}