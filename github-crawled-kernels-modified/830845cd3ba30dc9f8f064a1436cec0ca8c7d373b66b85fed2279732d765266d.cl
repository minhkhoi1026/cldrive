//{"inputImage":0,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void desaturate(float greyFactor, read_only image2d_t inputImage, write_only image2d_t outputImage) {
  int2 dimensions = get_image_dim(inputImage);
  int width = dimensions.x, height = dimensions.y;

  int x = get_global_id(0), y = get_global_id(1);

  const sampler_t sampler = 0 | 0x10 | 2;

  float4 pixel = read_imagef(inputImage, sampler, (int2)(x, y));

  float luminance = dot((float4)(1 / 3.f, 1 / 3.f, 1 / 3.f, 0), pixel);

  const float colorFactor = 1.f - greyFactor;
  float4 transformedPixel = colorFactor * pixel + greyFactor * ((float4)(luminance, luminance, luminance, 1.f));

  write_imagef(outputImage, (int2)(x, y), transformedPixel);
}

kernel void pass(read_only image2d_t inputImage, write_only image2d_t outputImage) {
  desaturate(0.5f, inputImage, outputImage);
}