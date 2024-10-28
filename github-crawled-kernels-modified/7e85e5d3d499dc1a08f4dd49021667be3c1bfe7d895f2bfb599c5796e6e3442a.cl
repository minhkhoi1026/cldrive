//{"height":3,"input":0,"inputOffset":1,"kernelBuffer":4,"kernelSize":5,"output":7,"outputOffset":8,"scale":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void separableConvolveXBuffer(global float* input, int inputOffset, int width, int height, constant float* kernelBuffer, const int kernelSize, float scale, global float* output, int outputOffset) {
  const int xOutput = get_global_id(0);
  const int yOutput = get_global_id(1);

  float sum = 0;
  int kSize = kernelSize;
  const int filterOffset = kernelSize / 2;
  const int intputPos = inputOffset + (yOutput * width) + (xOutput - filterOffset);
  const int outputPos = outputOffset + (yOutput * width) + xOutput;

  int imageStart = xOutput - filterOffset;
  int imageEnd = xOutput + filterOffset;
  int kernelStart = 0;

  if (imageStart < 0) {
    int shift = -imageStart;
    int pos = intputPos + shift;

    for (int i = 0; i < shift; i++)
      sum += kernelBuffer[hook(4, i)] * input[hook(0, pos)];

    kernelStart = shift;
  }

  if (imageEnd >= width) {
    int shift = imageEnd - width + 1;
    int pos = intputPos + (kernelSize - shift - 1);

    for (int i = kernelSize - shift; i < kernelSize; i++)
      sum += kernelBuffer[hook(4, i)] * input[hook(0, pos)];

    kSize -= shift;
  }

  for (int i = kernelStart; i < kSize; i++)
    sum += kernelBuffer[hook(4, i)] * input[hook(0, intputPos + i)];

  sum = sum * scale;
  output[hook(7, outputPos)] = sum;
}