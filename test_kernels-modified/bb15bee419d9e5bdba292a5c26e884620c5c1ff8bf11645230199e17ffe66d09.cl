//{"ascanAveragingFactor":8,"bscanAveragingFactor":9,"byteImage":13,"floatImage":12,"inputSpectraLength":4,"interpolationMatrix":2,"numAScansPerBScan":7,"numBScans":6,"outputAScanLength":5,"preProcessedCmplxSpectra":11,"referenceSpectrum":3,"resamplingTable":1,"spectra":0,"windowType":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void GPUResample(global float* spectra, global const float* resamplingTable, global const float* interpolationMatrix, unsigned int inputSpectraLength, global float* resampledSpectra);
void preProcess(global const short* spectrum, global const float* resamplingTable, global const float* interpolationMatrix, global const float* referenceSpectrum, global float* preProcessedCmplxSpectrum, unsigned int inputSpectraLength, unsigned int outputAScanLength, unsigned int windowType);
void ConvertFloatArrayToGreyScaleBitmap(global float* floatImage, const unsigned int x, const unsigned int inputHeight, const unsigned int inputWidth, const unsigned int imageFormatStride, const unsigned int inputStartIndex, const float minVal, const float maxVal, const unsigned int outputTop, const unsigned int outputHeight, const unsigned int outputStartIndex, global unsigned char* byteImage);
void ConvertFloatToGreyScaleBitmap(global float* floatImage, const unsigned int x, const unsigned int y, const unsigned int inputHeight, const unsigned int inputWidth, const unsigned int imageFormatStride, const unsigned int inputStartIndex, const float minVal, const float maxVal, const unsigned int outputTop, const unsigned int outputHeight, const unsigned int outputStartIndex, global unsigned char* byteImage);
void ConvertFloatArrayToGreyScaleBitmap(global float* floatImage, const unsigned int x, const unsigned int inputHeight, const unsigned int inputWidth, const unsigned int imageFormatStride, const unsigned int inputStartIndex, const float minVal, const float maxVal, const unsigned int outputTop, const unsigned int outputHeight, const unsigned int outputStartIndex, global unsigned char* byteImage) {
  unsigned int y;
  unsigned int outputBottom = outputTop + outputHeight;
  for (int y = outputTop; y < outputBottom; y++) {
    ConvertFloatToGreyScaleBitmap(floatImage, x, y, inputHeight, inputWidth, imageFormatStride, inputStartIndex, minVal, maxVal, outputTop, outputHeight, outputStartIndex, byteImage);
  }
}

void ConvertFloatToGreyScaleBitmap(global float* floatImage, const unsigned int x, const unsigned int y, const unsigned int inputHeight, const unsigned int inputWidth, const unsigned int imageFormatStride, const unsigned int inputStartIndex, const float minVal, const float maxVal, const unsigned int outputTop, const unsigned int outputHeight, const unsigned int outputStartIndex, global unsigned char* byteImage) {
  unsigned int yout;
  unsigned int i;
  unsigned int j;
  unsigned int outputBottom = outputTop + outputHeight;
  float span = maxVal - minVal;
  float val;
  unsigned char bVal;
  yout = y - outputTop;

  if ((x < inputWidth) && (y >= outputTop) && (y < outputBottom))

  {
    i = inputStartIndex + x * inputHeight + y;

    val = (floatImage[hook(12, i)] - minVal) / span * 255.0f;
    if (val > 255.0f)
      bVal = 255;
    else if (val < 0.0f)
      bVal = 0;
    else
      bVal = (unsigned char)val;

    j = outputStartIndex + (x * 3) + yout * imageFormatStride;

    byteImage[hook(13, j)] = bVal;
    byteImage[hook(13, j + 1)] = bVal;
    byteImage[hook(13, j + 2)] = bVal;
  }
}
kernel void octPreProcessingKernel(global const short* spectra, global const float* resamplingTable, global const float* interpolationMatrix, global const float* referenceSpectrum, const unsigned int inputSpectraLength, const unsigned int outputAScanLength, const unsigned int numBScans, const unsigned int numAScansPerBScan, const unsigned int ascanAveragingFactor, const unsigned int bscanAveragingFactor, const unsigned int windowType, global float* preProcessedCmplxSpectra)

{
  size_t ascanIndex = get_global_id(0);

  const size_t currentSpectraOffset = ascanIndex * (size_t)inputSpectraLength;

  const size_t currentAScanOffset = ascanIndex * (size_t)outputAScanLength;

  preProcess(&spectra[hook(0, currentSpectraOffset)], resamplingTable, interpolationMatrix, referenceSpectrum, &preProcessedCmplxSpectra[hook(11, 2 * currentAScanOffset)], inputSpectraLength, outputAScanLength, windowType);
}