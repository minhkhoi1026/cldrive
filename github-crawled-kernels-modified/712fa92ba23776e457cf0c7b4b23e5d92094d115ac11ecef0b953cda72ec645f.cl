//{"AttenuationDepth":11,"FourierTransformCmplx":0,"SAM":10,"Sum":9,"ascanAveragingFactor":5,"bscanAveragingFactor":6,"envBScan":7,"logEnvBScan":8,"numAScansPerBScan":4,"numBScans":3,"outputAScanLength":2,"referenceAScan":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void GPUResample(global float* spectra, global const float* resamplingTable, global const float* interpolationMatrix, unsigned int inputSpectraLength, global float* resampledSpectra);
void preProcess(global const short* spectrum, global const float* resamplingTable, global const float* interpolationMatrix, global const float* referenceSpectrum, global float* preProcessedCmplxSpectrum, unsigned int inputSpectraLength, unsigned int outputAScanLength, unsigned int windowType);
kernel void octPostProcessingKernel(global const float* FourierTransformCmplx, global const float* referenceAScan, const unsigned int outputAScanLength, const unsigned int numBScans, const unsigned int numAScansPerBScan, const unsigned int ascanAveragingFactor, const unsigned int bscanAveragingFactor, global float* envBScan, global float* logEnvBScan, global float* Sum, global float* SAM, global float* AttenuationDepth) {
  float re2;
  float im2;
  float sum = 0.0f;
  int i, count;
  int topOffset = 15;
  const unsigned int ascanIndex = get_global_id(0);

  const unsigned int currentAScanOffset = ascanIndex * outputAScanLength;

  for (i = 0; i < outputAScanLength; i++) {
    re2 = FourierTransformCmplx[hook(0, 2 * (currentAScanOffset + i))] * FourierTransformCmplx[hook(0, 2 * (currentAScanOffset + i))];
    im2 = FourierTransformCmplx[hook(0, 2 * (currentAScanOffset + i) + 1)] * FourierTransformCmplx[hook(0, 2 * (currentAScanOffset + i) + 1)];
    envBScan[hook(7, currentAScanOffset + i)] = re2 + im2;
    logEnvBScan[hook(8, currentAScanOffset + i)] = 20.0f * (float)log10(envBScan[hook(7, currentAScanOffset + i)]);
  }

  count = 0;
  for (i = topOffset; i < outputAScanLength / 8; i++) {
    sum += envBScan[hook(7, currentAScanOffset + i)];
    count++;
  }

  Sum[hook(9, ascanIndex)] = sum / (float)count;
}