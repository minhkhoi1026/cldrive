//{"ascanAveragingFactor":4,"bscanAveragingFactor":5,"bscans":0,"byteImage":14,"corrSizeX":6,"corrSizeY":7,"corrSizeZ":8,"correlationMap":12,"floatImage":13,"numAScansPerBScan":3,"numBScans":2,"offsetX":9,"offsetY":10,"offsetZ":11,"singleAScanLength":1}
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

    val = (floatImage[hook(13, i)] - minVal) / span * 255.0f;
    if (val > 255.0f)
      bVal = 255;
    else if (val < 0.0f)
      bVal = 0;
    else
      bVal = (unsigned char)val;

    j = outputStartIndex + (x * 3) + yout * imageFormatStride;

    byteImage[hook(14, j)] = bVal;
    byteImage[hook(14, j + 1)] = bVal;
    byteImage[hook(14, j + 2)] = bVal;
  }
}
kernel void octCorrelationKernel(global float* bscans, const unsigned int singleAScanLength, const unsigned int numBScans, const unsigned int numAScansPerBScan, const unsigned int ascanAveragingFactor, const unsigned int bscanAveragingFactor, const unsigned int corrSizeX, const unsigned int corrSizeY, const unsigned int corrSizeZ, const unsigned int offsetX, const unsigned int offsetY, const unsigned int offsetZ, global float* correlationMap)

{
  const int kernelIndex = get_global_id(0);

  int singleBScanLength = singleAScanLength * numAScansPerBScan;

  int totalAScanLength = singleAScanLength * ascanAveragingFactor;
  int totalBScanLength = singleBScanLength * ascanAveragingFactor * bscanAveragingFactor;
  int totalPixels = totalBScanLength * numBScans;
  int totalBScans = numBScans * bscanAveragingFactor;
  int totalAScansPerBScan = numAScansPerBScan * ascanAveragingFactor;
  int ascanIndex;
  int bscanIndex;
  int axialIndex;

  int x;
  int y;
  int z;
  int x1;
  int y1;
  int z1;
  int x2;
  int y2;
  int z2;
  int srcIndex1 = 0;
  int srcIndex2 = 0;
  int numPoints = 0;
  int i;

  int midX = (int)floor((float)corrSizeX / 2.0f);
  int midY = (int)floor((float)corrSizeY / 2.0f);
  int midZ = (int)floor((float)corrSizeZ / 2.0f);

  float corr = 0.0f;
  float meanVal1 = 0.0f;
  float meanVal2 = 0.0f;
  float sumVal = 0.0f;

  float diff1 = 0.0f;
  float diff2 = 0.0f;
  float sumDiff1Diff2 = 0.0f;
  float sumDiff1Diff1 = 0.0f;
  float sumDiff2Diff2 = 0.0f;

  bscanIndex = (int)floor((float)kernelIndex / (float)singleBScanLength);
  ascanIndex = (int)floor((float)(kernelIndex - bscanIndex * singleBScanLength) / (float)singleAScanLength);
  axialIndex = kernelIndex - bscanIndex * singleBScanLength - ascanIndex * singleAScanLength;

  if ((bscanIndex - midY >= 0) && (bscanIndex - midY + corrSizeY + offsetY - 1 < totalBScans)) {
    for (y = 0; y < corrSizeY; y++) {
      y1 = bscanIndex - midY + y;
      y2 = y1 + offsetY;

      for (x = 0; x < corrSizeX; x++) {
        x1 = ascanIndex - midX + x;
        x2 = x1 + offsetX;

        for (z = 0; z < corrSizeZ; z++) {
          z1 = axialIndex - midZ + z;
          z2 = z1 + offsetZ;
          srcIndex1 = y1 * singleBScanLength + x1 * singleAScanLength + z1;
          srcIndex2 = y2 * singleBScanLength + x2 * singleAScanLength + z2;

          if (((0 <= z1) && (z2 < singleAScanLength)) && ((0 <= y1) && (y2 < totalBScans)) && ((0 <= x1) && (x2 < totalAScansPerBScan)) && ((0 <= srcIndex1) && (srcIndex1 < totalPixels)) && ((0 <= srcIndex2) && (srcIndex2 < totalPixels))) {
            meanVal1 += bscans[hook(0, srcIndex1)];
            meanVal2 += bscans[hook(0, srcIndex2)];
            numPoints++;
          }
        }
      }
    }
    meanVal1 = meanVal1 / (float)numPoints;
    meanVal2 = meanVal2 / (float)numPoints;

    for (y = 0; y < corrSizeY; y++) {
      y1 = bscanIndex - midY + y;
      y2 = y1 + offsetY;

      for (x = 0; x < corrSizeX; x++) {
        x1 = ascanIndex - midX + x;
        x2 = x1 + offsetX;

        for (z = 0; z < corrSizeZ; z++) {
          z1 = axialIndex - midZ + z;
          z2 = z1 + offsetZ;
          srcIndex1 = y1 * singleBScanLength + x1 * singleAScanLength + z1;
          srcIndex2 = y2 * singleBScanLength + x2 * singleAScanLength + z2;

          if (((0 <= z1) && (z2 < singleAScanLength)) && ((0 <= y1) && (y2 < totalBScans)) && ((0 <= x1) && (x2 < totalAScansPerBScan)) && ((0 <= srcIndex1) && (srcIndex1 < totalPixels)) && ((0 <= srcIndex2) && (srcIndex2 < totalPixels))) {
            diff1 = bscans[hook(0, srcIndex1)] - meanVal1;
            diff2 = bscans[hook(0, srcIndex2)] - meanVal2;

            sumDiff1Diff2 += diff1 * diff2;
            sumDiff1Diff1 += diff1 * diff1;
            sumDiff2Diff2 += diff2 * diff2;
          }
        }
      }
    }

    corr = sumDiff1Diff2 / (sqrt(sumDiff1Diff1) * sqrt(sumDiff2Diff2));

    correlationMap[hook(12, kernelIndex)] = corr;

  } else {
    correlationMap[hook(12, kernelIndex)] = -2.0;
  }
}