//{"auxRandNumbers":1,"meanN":0,"nMax":2,"numEmissions":3,"numPtcls":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float lineShape(float gamma, float delta, float S);
float peakScatteringRate(float3 k, float3 v, float gamma, float delta, float S);
float gaussianBeamProfile(float3 k, float3 r0, float sigma, float3 r);
kernel void countEmissions(global float* meanN, global float* auxRandNumbers, int nMax, global int* numEmissions, int numPtcls) {
  int i = get_global_id(0);
  if (i < numPtcls) {
    float z = meanN[hook(0, i)] / nMax;
    auxRandNumbers += i;
    int actualN = 0;
    for (int j = 0; j < nMax; ++j) {
      if (*auxRandNumbers < z) {
        actualN += 1;
      }
      auxRandNumbers += numPtcls;
    }
    numEmissions[hook(3, i)] = actualN;
  }
}