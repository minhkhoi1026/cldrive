//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_csc_rgba64torgba(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_in = read_imagef(input, sampler, (int2)(x, y));
  write_imagef(output, (int2)(x, y), pixel_in);
}