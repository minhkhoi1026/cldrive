//{"inputImage":0,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void performBlur(int blurSize, read_only image2d_t inputImage, write_only image2d_t outputImage) {
  int2 dimensions = get_image_dim(inputImage);
  int width = dimensions.x, height = dimensions.y;

  int x = get_global_id(0), y = get_global_id(1);

  float4 transformedPixel = (float4)0;

  const sampler_t sampler = 0 | 0x10 | 2;

  int minDiff = -(blurSize - 1);
  for (int dx = minDiff; dx < blurSize; dx++) {
    for (int dy = minDiff; dy < blurSize; dy++) {
      float4 pixel = read_imagef(inputImage, sampler, (int2)(x + dx, y + dy));
      transformedPixel += pixel;
    }
  }

  int n = (2 * blurSize - 1);
  n *= n;

  transformedPixel /= (float)n;

  write_imagef(outputImage, (int2)(x, y), transformedPixel);
}

kernel void pass1(read_only image2d_t inputImage, write_only image2d_t outputImage) {
  performBlur(10, inputImage, outputImage);
}