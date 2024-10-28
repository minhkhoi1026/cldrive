//{"byteImage":6,"floatImage":0,"imageFormatStride":3,"imageHeight":2,"imageWidth":1,"maxVal":5,"minVal":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void GPUResample(global float* spectra, global const float* resamplingTable, global const float* interpolationMatrix, unsigned int inputSpectraLength, global float* resampledSpectra);
void preProcess(global const short* spectrum, global const float* resamplingTable, global const float* interpolationMatrix, global const float* referenceSpectrum, global float* preProcessedCmplxSpectrum, unsigned int inputSpectraLength, unsigned int outputAScanLength, unsigned int windowType);
kernel void ConvertFloatArrayToGreyScaleImage(global const float* floatImage, const unsigned int imageWidth, const unsigned int imageHeight, const unsigned int imageFormatStride, const float minVal, const float maxVal, global unsigned char* byteImage) {
  const unsigned int x = get_global_id(0);
  unsigned int y;
  float span = maxVal - minVal;
  float val;
  unsigned char bVal;

  if (x < imageWidth) {
    for (int y = 0; y < imageHeight; y++) {
      val = (floatImage[hook(0, x * imageHeight * 2 + y)] - minVal) / span * 255.0f;
      bVal = (unsigned char)val;
      if (val > 255.0f)
        bVal = 255;
      if (val < 0.0f)
        bVal = 0;

      byteImage[hook(6, (x * 3) + y * imageFormatStride)] = bVal;
      byteImage[hook(6, (x * 3) + y * imageFormatStride + 1)] = bVal;
      byteImage[hook(6, (x * 3) + y * imageFormatStride + 2)] = bVal;
    }
  }
}