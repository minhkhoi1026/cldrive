//{"height":3,"input":0,"inputOffset":1,"kernelBuffer":4,"kernelSize":5,"output":7,"outputOffset":8,"scale":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void separableConvolveYBuffer(global float* input, int inputOffset, int width, int height, constant float* kernelBuffer, const int kernelSize, float scale, global float* output, int outputOffset) {
  const int xOutput = get_global_id(0);
  const int yOutput = get_global_id(1);

  float sum = 0;
  const int filterOffset = kernelSize / 2;
  const int intputPos = inputOffset + ((yOutput - filterOffset) * width) + xOutput;
  const int outputPos = outputOffset + (yOutput * width) + xOutput;

  int imageStart = yOutput - filterOffset;
  int imageEnd = yOutput + filterOffset;
  int kernelStart = 0;
  int kSize = kernelSize;

  if (imageStart < 0) {
    int shift = -imageStart;
    int pos = intputPos + (shift * width);

    for (int i = 0; i < shift; i++)
      sum += kernelBuffer[hook(4, i)] * input[hook(0, pos)];

    kernelStart = shift;
  }

  if (imageEnd >= height) {
    int shift = imageEnd - height + 1;
    int pos = intputPos + ((kernelSize - shift - 1) * width);

    for (int i = kernelSize - shift; i < kernelSize; i++)
      sum += kernelBuffer[hook(4, i)] * input[hook(0, pos)];

    kSize -= shift;
  }

  for (int i = kernelStart; i < kSize; i++)
    sum += kernelBuffer[hook(4, i)] * input[hook(0, intputPos + (i * width))];

  sum = sum * scale;
  output[hook(7, outputPos)] = sum;
}