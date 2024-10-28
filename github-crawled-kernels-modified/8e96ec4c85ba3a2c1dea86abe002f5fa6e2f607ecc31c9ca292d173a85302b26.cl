//{"height":7,"input":0,"kernelSize":2,"kernelX":1,"offset":5,"output":4,"scale":3,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void separableConvolveXImage2DBuffer(read_only image2d_t input, constant float* kernelX, const int kernelSize, float scale, global float* output, int offset, int width, int height) {
  const sampler_t nearestClampSampler = 0 | 0x10 | 2;

  const int xOutput = get_global_id(0);
  const int yOutput = get_global_id(1);

  float sum = 0;
  int filterOffset = kernelSize / 2;
  int xInput = xOutput - filterOffset;
  int outputPos = offset + (yOutput * width) + xOutput;

  for (int x = 0; x < kernelSize; x++) {
    float value = read_imagef(input, nearestClampSampler, (int2)(xInput + x, yOutput)).x;

    sum += kernelX[hook(1, x)] * value;
  }

  sum = sum * scale;
  output[hook(4, outputPos)] = sum;
}