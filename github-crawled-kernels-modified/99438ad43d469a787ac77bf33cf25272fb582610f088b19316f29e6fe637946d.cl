//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_csc_yuyvtorgba(read_only image2d_t input, write_only image2d_t output) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;
  float4 pixel_in1 = read_imagef(input, sampler, (int2)(x, y));
  float4 pixel_out1, pixel_out2;
  pixel_out1.x = pixel_in1.x + 1.13983 * (pixel_in1.w - 0.5);
  pixel_out1.y = pixel_in1.x - 0.39465 * (pixel_in1.y - 0.5) - 0.5806 * (pixel_in1.w - 0.5);
  pixel_out1.z = pixel_in1.x + 2.03211 * (pixel_in1.y - 0.5);
  pixel_out1.w = 0.0;
  pixel_out2.x = pixel_in1.z + 1.13983 * (pixel_in1.w - 0.5);
  pixel_out2.y = pixel_in1.z - 0.39465 * (pixel_in1.y - 0.5) - 0.5806 * (pixel_in1.w - 0.5);
  pixel_out2.z = pixel_in1.z + 2.03211 * (pixel_in1.y - 0.5);
  pixel_out2.w = 0.0;
  write_imagef(output, (int2)(2 * x, y), pixel_out1);
  write_imagef(output, (int2)(2 * x + 1, y), pixel_out2);
}