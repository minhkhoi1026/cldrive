//{"filter":2,"filterWidth":3,"inputImage":0,"outputImage":1,"sampler":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution(read_only image2d_t inputImage, write_only image2d_t outputImage, constant float* filter, int filterWidth, sampler_t sampler) {
  int column = get_global_id(0);
  int row = get_global_id(1);

  int halfWidth = (int)(filterWidth / 2);

  float4 sum = {0.0f, 0.0f, 0.0f, 0.0f};

  int filterIdx = 0;

  int2 coords;

  for (int i = -halfWidth; i <= halfWidth; i++) {
    coords.y = row + i;

    for (int j = -halfWidth; j <= halfWidth; j++) {
      coords.x = column + j;

      float4 pixel;
      pixel = read_imagef(inputImage, sampler, coords);
      sum.x += pixel.x * filter[hook(2, filterIdx++)];
    }
  }

  coords.x = column;
  coords.y = row;
  write_imagef(outputImage, coords, sum);
}