//{"in_local":6,"nFilterHeight":4,"nFilterWidth":3,"pBias":5,"pFilter":1,"pInput":0,"pOutput":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve(const global float* pInput, constant float* pFilter, global float* pOutput, const int nFilterWidth, const int nFilterHeight, global const float* pBias, local float* in_local) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int OWidth = get_global_size(0);
  const int OHeight = get_global_size(1);

  const int ImWidth = OWidth + nFilterWidth - 1;
  const int ImHeight = OHeight + nFilterHeight - 1;
  float sum = 0;
  for (int r = 0; r < nFilterHeight; r++) {
    for (int c = 0; c < nFilterWidth; c++) {
      sum += pFilter[hook(1, r * nFilterWidth + c)] * pInput[hook(0, (y + r) * ImWidth + x + c)];
    }
  }
  pOutput[hook(2, (y * OWidth) + x)] = sum + *pBias;
}