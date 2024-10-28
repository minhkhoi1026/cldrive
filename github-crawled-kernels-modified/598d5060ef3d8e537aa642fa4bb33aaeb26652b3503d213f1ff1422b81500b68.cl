//{"AttenuationDepth":11,"FourierTransformCmplx":0,"SAM":10,"Sum":9,"ascanAveragingFactor":5,"bscanAveragingFactor":6,"envBScan":7,"logEnvBScan":8,"numAScansPerBScan":4,"numBScans":3,"outputAScanLength":2,"referenceAScan":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void GPUResample(global float* spectra, global const float* resamplingTable, global const float* interpolationMatrix, unsigned int inputSpectraLength, global float* resampledSpectra);
void preProcess(global const short* spectrum, global const float* resamplingTable, global const float* interpolationMatrix, global const float* referenceSpectrum, global float* preProcessedCmplxSpectrum, unsigned int inputSpectraLength, unsigned int outputAScanLength, unsigned int windowType);
kernel void octPostProcessingKernel(global const float* FourierTransformCmplx, global const float* referenceAScan, const unsigned int outputAScanLength, const unsigned int numBScans, const unsigned int numAScansPerBScan, const unsigned int ascanAveragingFactor, const unsigned int bscanAveragingFactor, global float* envBScan, global float* logEnvBScan, global float* Sum, global float* SAM, global float* AttenuationDepth) {
  float re, im, env;
  float re2;
  float im2;
  float sum;
  unsigned int count;
  unsigned int i, rei, imi, ii;
  unsigned int topOffset = 15;
  const size_t ascanIndex = get_global_id(0);

  const size_t currentAScanOffset = (size_t)ascanIndex * (size_t)outputAScanLength;

  count = 0;
  sum = 0.0f;

  for (i = 0; i < outputAScanLength; i++) {
    ii = currentAScanOffset + i;
    rei = 2 * ii;
    imi = rei + 1;
    re = FourierTransformCmplx[hook(0, rei)];
    im = FourierTransformCmplx[hook(0, imi)];
    re2 = re * re;
    im2 = im * im;
    env = re2 + im2;
    envBScan[hook(7, ii)] = env;
    logEnvBScan[hook(8, ii)] = 20.0f * native_log10(env);

    if ((topOffset < i) && (i < outputAScanLength / 8)) {
      sum += env;
      count++;
    }
  }
  Sum[hook(9, ascanIndex)] = sum / (float)count;
}