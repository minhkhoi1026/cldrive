//{"nFilterWidth":4,"nInWidth":3,"pFilter":1,"pInput":0,"pOutput":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Convolve(const global float* pInput, constant float* pFilter, global float* pOutput, const int nInWidth, const int nFilterWidth) {
  const int nWidth = get_global_size(0);

  const int xOut = get_global_id(0);
  const int yOut = get_global_id(1);

  const int xInTopLeft = xOut;
  const int yInTopLeft = yOut;

  float sum = 0;
  for (int r = 0; r < nFilterWidth; r++) {
    const int idxFtmp = r * nFilterWidth;

    const int yIn = yInTopLeft + r;
    const int idxIntmp = yIn * nInWidth + xInTopLeft;

    for (int c = 0; c < nFilterWidth; c++) {
      const int idxF = idxFtmp + c;
      const int idxIn = idxIntmp + c;
      sum += pFilter[hook(1, idxF)] * pInput[hook(0, idxIn)];
    }
  }
  const int idxOut = yOut * nWidth + xOut;
  pOutput[hook(2, idxOut)] = sum;
}