//{"AttenuationDepth":14,"FourierTransformCmplx":0,"SAM":13,"Sum":12,"ascanAveragingFactor":5,"bscanAveragingFactor":6,"bscanBmp":15,"byteImage":17,"envBScan":10,"floatImage":16,"imageFormatStride":7,"logEnvBScan":11,"maxVal":9,"minVal":8,"numAScansPerBScan":4,"numBScans":3,"outputAScanLength":2,"referenceAScan":1}
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

    val = (floatImage[hook(16, i)] - minVal) / span * 255.0f;
    if (val > 255.0f)
      bVal = 255;
    else if (val < 0.0f)
      bVal = 0;
    else
      bVal = (unsigned char)val;

    j = outputStartIndex + (x * 3) + yout * imageFormatStride;

    byteImage[hook(17, j)] = bVal;
    byteImage[hook(17, j + 1)] = bVal;
    byteImage[hook(17, j + 2)] = bVal;
  }
}
kernel void octPostProcessingKernel(global const float* FourierTransformCmplx, global const float* referenceAScan, const unsigned int outputAScanLength, const unsigned int numBScans, const unsigned int numAScansPerBScan, const unsigned int ascanAveragingFactor, const unsigned int bscanAveragingFactor, const unsigned int imageFormatStride, const float minVal, const float maxVal, global float* envBScan, global float* logEnvBScan, global float* Sum, global float* SAM, global float* AttenuationDepth, global char* bscanBmp) {
  float re, im, env;
  float re2;
  float im2;
  float sum;
  float refVal;
  unsigned int count;
  unsigned int i, rei, imi, ii;
  unsigned int topOffset = 15;
  unsigned int bscanWidth = numAScansPerBScan * ascanAveragingFactor;
  unsigned int bscanHeight = outputAScanLength / 2;

  const size_t totalBScans = numBScans * bscanAveragingFactor;
  const size_t totalAScansPerBScan = numAScansPerBScan * ascanAveragingFactor;
  const size_t totalAScans = totalAScansPerBScan * totalBScans;
  const size_t ascanIndex = get_global_id(0);
  const size_t currentAScanOffset = (size_t)ascanIndex * (size_t)outputAScanLength;
  const size_t currentBScanIndex = (size_t)floor((float)ascanIndex / (float)totalAScans * (float)totalBScans);
  const size_t inputBScanOffset = currentBScanIndex * totalAScansPerBScan * (size_t)outputAScanLength;
  const size_t outputBScanOffset = currentBScanIndex * (size_t)imageFormatStride * (size_t)bscanHeight;

  unsigned int x = ascanIndex % bscanWidth;

  count = 0;
  sum = 0.0f;

  for (i = 0; i < outputAScanLength; i++) {
    ii = currentAScanOffset + i;
    refVal = referenceAScan[hook(1, i)];
    rei = 2 * ii;
    imi = rei + 1;
    re = FourierTransformCmplx[hook(0, rei)];
    im = FourierTransformCmplx[hook(0, imi)];
    re2 = re * re;
    im2 = im * im;
    env = re2 + im2;
    envBScan[hook(10, ii)] = env;
    logEnvBScan[hook(11, ii)] = 20.0f * native_log10(env) - refVal;

    if ((topOffset < i) && (i < outputAScanLength / 8)) {
      sum += env;
      count++;
    }

    ConvertFloatToGreyScaleBitmap(logEnvBScan, x, i, outputAScanLength, bscanWidth, imageFormatStride, inputBScanOffset, minVal, maxVal, 0, bscanHeight, outputBScanOffset, bscanBmp);
  }
  Sum[hook(12, ascanIndex)] = sum / (float)count;
}