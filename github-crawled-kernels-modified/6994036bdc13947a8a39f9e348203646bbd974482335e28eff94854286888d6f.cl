//{"input":0,"kernelSize":2,"kernelX":1,"output":4,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void separableConvolveXImage2D(read_only image2d_t input, constant float* kernelX, int kernelSize, float scale, write_only image2d_t output) {
  const sampler_t nearestClampSampler = 0 | 0x10 | 2;

  const int globalX = get_global_id(0);
  const int globalY = get_global_id(1);

  float sum = 0;
  int filterOffset = kernelSize / 2;
  int xInput = globalX - filterOffset;

  for (int x = 0; x < kernelSize; x++) {
    float value = read_imagef(input, nearestClampSampler, (int2)(xInput + x, globalY)).x;

    sum += kernelX[hook(1, x)] * value;
  }

  sum = sum * scale;
  write_imagef(output, (int2)(globalX, globalY), sum);
}