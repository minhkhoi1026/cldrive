//{"cols":2,"filter":4,"filterWidth":5,"inputImage":0,"outputPipe":3,"rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 2;
kernel void producerKernel(image2d_t read_only inputImage, int rows, int cols, global float* outputPipe, constant float* filter, int filterWidth) {
  int column = get_global_id(0);
  int row = get_global_id(1);

  int halfWidth = (int)(filterWidth / 2);

  float sum = 0.0f;

  int filterIdx = 0;

  int2 coords;

  for (int i = -halfWidth; i <= halfWidth; i++) {
    coords.y = row + i;

    for (int j = -halfWidth; j <= halfWidth; j++) {
      coords.x = column + j;

      float4 pixel;
      pixel = read_imagef(inputImage, sampler, coords);
      sum += pixel.x * filter[hook(4, filterIdx++)];
    }
  }

  int gid = row * cols + column;
  outputPipe[hook(3, gid)] = sum;
}