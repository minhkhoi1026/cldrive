//{"cols":3,"filter":4,"filterWidth":5,"outputImage":1,"rows":2,"sampler":6,"sourceImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolution(read_only image2d_t sourceImage, write_only image2d_t outputImage, unsigned int rows, unsigned int cols, constant float* filter, unsigned int filterWidth, sampler_t sampler) {
  unsigned int column = get_global_id(0);
  unsigned int row = get_global_id(1);

  int halfwidth = filterWidth / 2;

  float sum = 0;

  int filterIdx = 0;

  int2 coords;

  for (int i = -halfwidth; i <= halfwidth; ++i) {
    coords.y = row + i;

    for (int j = -halfwidth; j <= halfwidth; ++j) {
      coords.x = column + j;

      uint4 pixel;

      pixel = read_imageui(sourceImage, sampler, coords);
      sum += pixel.x * filter[hook(4, filterIdx++)];
    }
  }

  if (row < rows && column < cols) {
    coords.x = column;
    coords.y = row;
    uint4 float3 = {sum, 0, 0, 0};
    write_imageui(outputImage, coords, float3);
  }
}