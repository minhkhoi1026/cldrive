//{"inputImage":0,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 4 | 0x20;
kernel void sobel_filter(read_only image2d_t inputImage, write_only image2d_t outputImage) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  float4 Gx = (float4)(0);
  float4 Gy = Gx;

  float4 i00 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x - 1, coord.y + 1)));
  float4 i10 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x - 0, coord.y + 1)));
  float4 i20 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x + 1, coord.y + 1)));
  float4 i01 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x - 1, coord.y + 0)));
  float4 i11 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x - 0, coord.y + 0)));
  float4 i21 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x + 1, coord.y + 0)));
  float4 i02 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x - 1, coord.y - 1)));
  float4 i12 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x - 0, coord.y - 1)));
  float4 i22 = convert_float4(read_imageui(inputImage, imageSampler, (int2)(coord.x + 1, coord.y - 1)));

  Gx = i00 + (float4)(2) * i10 + i20 - i02 - (float4)(2) * i12 - i22;

  Gy = i00 - i20 + (float4)(2) * i01 - (float4)(2) * i21 + i02 - i22;

  Gx = native_divide(native_sqrt(Gx * Gx + Gy * Gy), (float4)(2));

  write_imageui(outputImage, coord, convert_uint4(Gx));
}