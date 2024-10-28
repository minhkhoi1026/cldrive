//{"input":0,"output":1,"table":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_gamma(read_only image2d_t input, write_only image2d_t output, global float* table) {
  int x = get_global_id(0);
  int y = get_global_id(1);
  sampler_t sampler = 0 | 0 | 0x10;
  int2 pos = (int2)(x, y);
  float4 pixel_in, pixel_out;
  pixel_in = read_imagef(input, sampler, pos);
  pixel_out.x = table[hook(2, convert_int(pixel_in.x * 255.))] / 255.0;
  pixel_out.y = table[hook(2, convert_int(pixel_in.y * 255.))] / 255.0;
  pixel_out.z = table[hook(2, convert_int(pixel_in.z * 255.))] / 255.0;
  pixel_out.w = 0.0;
  write_imagef(output, pos, pixel_out);
}