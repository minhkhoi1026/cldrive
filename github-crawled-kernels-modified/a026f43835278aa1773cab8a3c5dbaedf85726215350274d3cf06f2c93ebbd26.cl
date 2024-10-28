//{"inputImage":0,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void test(read_only image2d_t inputImage, write_only image2d_t outputImage) {
  int2 dimensions = get_image_dim(inputImage);
  int width = dimensions.x, height = dimensions.y;

  int channelDataType = get_image_channel_data_type(inputImage);

  int channelOrder = get_image_channel_order(inputImage);

  int x = get_global_id(0);
  int y = get_global_id(1);
  int2 coordinates = (int2)(x, y);

  float4 pixel = read_imagef(inputImage, sampler, coordinates);

  float4 transformedPixel = (float4)(0);

  write_imagef(outputImage, coordinates, transformedPixel);
}