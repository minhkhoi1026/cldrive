//{"input":0,"kernelSize":2,"kernelY":1,"output":4,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void separableConvolveYImage2D(read_only image2d_t input, constant float* kernelY, const int kernelSize, float scale, write_only image2d_t output) {
  const sampler_t nearestClampSampler = 0 | 0x10 | 2;

  const int xOutput = get_global_id(0);
  const int yOutput = get_global_id(1);

  float sum = 0;
  int kSize = kernelSize;
  int filterOffset = kernelSize / 2;
  int yInput = yOutput - filterOffset;

  for (int y = 0; y < kernelSize; y++) {
    float value = read_imagef(input, nearestClampSampler, (int2)(xOutput, yInput + y)).x;

    sum += kernelY[hook(1, y)] * value;
  }

  sum = sum * scale;
  write_imagef(output, (int2)(xOutput, yOutput), sum);
}