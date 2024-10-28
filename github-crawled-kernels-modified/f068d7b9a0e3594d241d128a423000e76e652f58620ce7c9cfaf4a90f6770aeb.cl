//{"cols":3,"outputImage":1,"rows":2,"sampler":4,"sourceImage":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalizeImg(read_only image2d_t sourceImage, write_only image2d_t outputImage, unsigned int rows, unsigned int cols, sampler_t sampler) {
  unsigned int column = get_global_id(0);
  unsigned int row = get_global_id(1);

  int2 coords = (int2)(column, row);

  uint4 pixel = read_imageui(sourceImage, sampler, coords);

  if (row < rows && column < cols) {
    float4 pixelf = convert_float4(pixel) / 255.f;
    pixelf.w = 1.f;
    write_imagef(outputImage, coords, pixelf);
  }
}