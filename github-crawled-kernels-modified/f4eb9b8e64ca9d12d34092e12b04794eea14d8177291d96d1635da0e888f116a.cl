//{"input":0,"output":1,"output_height":3,"output_widht":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_image_scaler(read_only image2d_t input, write_only image2d_t output, const unsigned int output_widht, const unsigned int output_height) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  const sampler_t sampler = 1 | 2 | 0x20;

  float2 normCoor = convert_float2((int2)(x, y)) / (float2)(output_widht, output_height);
  float4 scaled_pixel = read_imagef(input, sampler, normCoor);
  write_imagef(output, (int2)(x, y), scaled_pixel);
}