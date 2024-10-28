//{"nInputs":3,"pBias":4,"pInput":0,"pOutput":2,"pWeights":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void iplayer(const global float* pInput, const global float* pWeights, global float* pOutput, const int nInputs, const global float* pBias) {
  const int x = get_global_id(0);
  const int idxstart = x * nInputs;
  float sum = 0;
  for (int i = 0; i < nInputs; i++) {
    sum += pWeights[hook(1, idxstart + i)] * pInput[hook(0, i)];
  }
  pOutput[hook(2, x)] = sum + pBias[hook(4, x)];
}