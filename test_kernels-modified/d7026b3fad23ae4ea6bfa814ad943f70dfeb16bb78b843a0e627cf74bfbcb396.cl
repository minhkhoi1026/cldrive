//{"ascanAveragingFactor":8,"bscanAveragingFactor":9,"inputSpectraLength":4,"interpolationMatrix":2,"numAScansPerBScan":7,"numBScans":6,"outputAScanLength":5,"preProcessedCmplxSpectra":11,"referenceSpectrum":3,"resamplingTable":1,"spectra":0,"windowType":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void GPUResample(global float* spectra, global const float* resamplingTable, global const float* interpolationMatrix, unsigned int inputSpectraLength, global float* resampledSpectra);
void preProcess(global const short* spectrum, global const float* resamplingTable, global const float* interpolationMatrix, global const float* referenceSpectrum, global float* preProcessedCmplxSpectrum, unsigned int inputSpectraLength, unsigned int outputAScanLength, unsigned int windowType);
kernel void octPreProcessingKernel(global const short* spectra, global const float* resamplingTable, global const float* interpolationMatrix, global const float* referenceSpectrum, const unsigned int inputSpectraLength, const unsigned int outputAScanLength, const unsigned int numBScans, const unsigned int numAScansPerBScan, const unsigned int ascanAveragingFactor, const unsigned int bscanAveragingFactor, const unsigned int windowType, global float* preProcessedCmplxSpectra) {
  size_t ascanIndex = get_global_id(0);

  const size_t currentSpectraOffset = ascanIndex * (size_t)inputSpectraLength;

  const size_t currentAScanOffset = ascanIndex * (size_t)outputAScanLength;

  preProcess(&spectra[hook(0, currentSpectraOffset)], resamplingTable, interpolationMatrix, referenceSpectrum, &preProcessedCmplxSpectra[hook(11, 2 * currentAScanOffset)], inputSpectraLength, outputAScanLength, windowType);
}