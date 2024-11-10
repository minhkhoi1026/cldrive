//{"color_bits":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tonemapping(read_only image2d_t input, write_only image2d_t output, unsigned int color_bits) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 2 | 0x10;

  float4 p;
  p = read_imagef(input, sampler, (int2)(x, y));
  write_imagef(output, (int2)(x, y), p);
}