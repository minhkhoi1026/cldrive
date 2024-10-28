//{"inputImage":0,"outputImage":1,"testbuf":2,"testbufOut":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void test(read_only image2d_t inputImage, write_only image2d_t outputImage, global float* testbuf, global float* testbufOut) {
  int2 dimensions = get_image_dim(inputImage);
  int width = dimensions.x, height = dimensions.y;

  int x = get_global_id(0), y = get_global_id(1);

  float4 pixel = read_imagef(inputImage, sampler, (int2)(x, y));

  float red = pixel.x, green = pixel.y, blue = pixel.z, alpha = pixel.w;

  float4 transformedPixel = testbuf[hook(2, 0)] * (float4)(red, green, blue, alpha);

  write_imagef(outputImage, (int2)(x, y), transformedPixel);
}