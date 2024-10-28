//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_demo(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;

  int2 pos = (int2)(x, y);
  uint4 pixel = read_imageui(input, sampler, pos);
  write_imageui(output, pos, pixel);
}