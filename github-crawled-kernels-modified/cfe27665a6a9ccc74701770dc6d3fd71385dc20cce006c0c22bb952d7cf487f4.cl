//{"inputImage":0,"matrix":2,"matrixW":6,"matrixX":3,"matrixY":4,"matrixZ":5,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 convolveFloatImagePixel(read_only image2d_t inputImage, int x, int y, constant float* matrix, int matrixSize) {
  const sampler_t sampler = 0 | 0x10 | 2;

  float4 total = (float4)0;
  int matrixCenterOffset = matrixSize / 2;

  for (int dy = 0; dy < matrixSize; dy++) {
    int offset = dy * matrixSize;
    for (int dx = 0; dx < matrixSize; dx++) {
      float4 pixel = read_imagef(inputImage, sampler, (int2)(x + dx - matrixCenterOffset, y + dy - matrixCenterOffset));
      float factor = matrix[hook(2, offset + dx)];
      total += factor * pixel;
    }
  }
  return total;
}
float4 convolveFloatImagePixelChannels(read_only image2d_t inputImage, int x, int y, constant float* matrixX, constant float* matrixY, constant float* matrixZ, constant float* matrixW, int matrixSize) {
  const sampler_t sampler = 0 | 0x10 | 2;

  float4 total = (float4)0;
  int matrixCenterOffset = matrixSize / 2;

  for (int dy = 0; dy < matrixSize; dy++) {
    int offset = dy * matrixSize;
    for (int dx = 0; dx < matrixSize; dx++) {
      float4 pixel = read_imagef(inputImage, sampler, (int2)(x + dx - matrixCenterOffset, y + dy - matrixCenterOffset));
      int pos = offset + dx;
      float4 factors = (float4)(matrixX[hook(3, pos)], matrixY[hook(4, pos)], matrixZ[hook(5, pos)], matrixW[hook(6, pos)]);
      total += factors * pixel;
    }
  }
  return total;
}
float convolveFloatImagePixelX(read_only image2d_t inputImage, int x, int y, constant float* matrix, int matrixSize) {
  const sampler_t sampler = 0 | 0x10 | 2;

  float total = 0;
  int matrixCenterOffset = matrixSize / 2;

  for (int dy = 0; dy < matrixSize; dy++) {
    int offset = dy * matrixSize;
    for (int dx = 0; dx < matrixSize; dx++) {
      float4 pixel = read_imagef(inputImage, sampler, (int2)(x + dx - matrixCenterOffset, y + dy - matrixCenterOffset));
      float factor = matrix[hook(2, offset + dx)];
      total += factor * pixel.x;
    }
  }
  return total;
}
float convolveFloatImagePixelGray(read_only image2d_t inputImage, int x, int y, constant float* matrix, int matrixSize) {
  const sampler_t sampler = 0 | 0x10 | 2;

  float total = 0;
  int matrixCenterOffset = matrixSize / 2;

  const float4 luminanceDot = (float4)(1 / 3.f, 1 / 3.f, 1 / 3.f, 0);
  for (int dy = 0; dy < matrixSize; dy++) {
    int offset = dy * matrixSize;
    for (int dx = 0; dx < matrixSize; dx++) {
      float4 pixel = read_imagef(inputImage, sampler, (int2)(x + dx - matrixCenterOffset, y + dy - matrixCenterOffset));
      float factor = matrix[hook(2, offset + dx)];
      total += factor * dot(luminanceDot, pixel);
    }
  }
  return total;
}
float2 convolveFloatImagePixelGray2(read_only image2d_t inputImage, int x, int y, constant float2* matrix, int matrixSize) {
  const sampler_t sampler = 0 | 0x10 | 2;

  float2 total = (float2)0;
  int matrixCenterOffset = matrixSize / 2;

  const float4 luminanceDot = (float4)(1 / 3.f, 1 / 3.f, 1 / 3.f, 0);
  for (int dy = 0; dy < matrixSize; dy++) {
    int offset = dy * matrixSize;
    for (int dx = 0; dx < matrixSize; dx++) {
      float4 pixel = read_imagef(inputImage, sampler, (int2)(x + dx - matrixCenterOffset, y + dy - matrixCenterOffset));
      float2 factor = matrix[hook(2, offset + dx)];
      total += factor * dot(luminanceDot, pixel);
    }
  }
  return total;
}

void convolveFloatImage(read_only image2d_t inputImage, constant float* matrix, int matrixSize, write_only image2d_t outputImage) {
  int x = get_global_id(0), y = get_global_id(1);

  float4 total = convolveFloatImagePixel(inputImage, x, y, matrix, matrixSize);

  total.w = 1;
  write_imagef(outputImage, (int2)(x, y), total);
}
void convolveFloatImageChannels(read_only image2d_t inputImage, constant float* matrixX, constant float* matrixY, constant float* matrixZ, constant float* matrixW, int matrixSize, write_only image2d_t outputImage) {
  int x = get_global_id(0), y = get_global_id(1);

  float4 total = convolveFloatImagePixelChannels(inputImage, x, y, matrixX, matrixY, matrixZ, matrixW, matrixSize);
  total.w = 1;
  write_imagef(outputImage, (int2)(x, y), total);
}

constant float gaussian7x7Matrix[] = {0.00000067f, 0.00002292f, 0.00019117f, 0.00038771f, 0.00019117f, 0.00002292f, 0.00000067f, 0.00002292f, 0.00078633f, 0.00655965f, 0.01330373f, 0.00655965f, 0.00078633f, 0.00002292f, 0.00019117f, 0.00655965f, 0.05472157f, 0.11098164f, 0.05472157f, 0.00655965f, 0.00019117f, 0.00038771f, 0.01330373f, 0.11098164f, 0.22508352f, 0.11098164f, 0.01330373f, 0.00038771f, 0.00019117f, 0.00655965f, 0.05472157f, 0.11098164f, 0.05472157f, 0.00655965f, 0.00019117f, 0.00002292f, 0.00078633f, 0.00655965f, 0.01330373f, 0.00655965f, 0.00078633f, 0.00002292f, 0.00000067f, 0.00002292f, 0.00019117f, 0.00038771f, 0.00019117f, 0.00002292f, 0.00000067f};

kernel void convolve(read_only image2d_t inputImage, write_only image2d_t outputImage) {
  convolveFloatImage(inputImage, gaussian7x7Matrix, 7, outputImage);
}