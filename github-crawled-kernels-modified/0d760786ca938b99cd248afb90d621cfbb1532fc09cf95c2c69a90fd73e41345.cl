//{"input":0,"kernelBuffer":1,"kernelSize":2,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve(read_only image2d_t input, constant float* kernelBuffer, const int kernelSize, write_only image2d_t output) {
  const sampler_t nearestClampSampler = 0 | 0x10 | 2;
  const int xOutput = get_global_id(0);
  const int yOutput = get_global_id(1);
  float sum = 0;

  int filterOffset = kernelSize / 2;
  int xInput = xOutput - filterOffset;
  int yInput = yOutput - filterOffset;

  for (int row = 0; row < kernelSize; row++) {
    const int indexFilterRow = row * kernelSize;
    const int yInputRow = yInput + row;

    for (int col = 0; col < kernelSize; col++) {
      const int indexFilter = indexFilterRow + col;
      float value = read_imagef(input, nearestClampSampler, (int2)(xInput + col, yInputRow)).x;

      sum += kernelBuffer[hook(1, indexFilter)] * value;
    }
  }
  write_imagef(output, (int2)(xOutput, yOutput), sum);
}