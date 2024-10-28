//{"nFilterHeight":4,"nFilterWidth":3,"nInMaps":5,"pBias":6,"pFilter":1,"pInput":0,"pOutput":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter3D_unroll(const global float* pInput, constant float* pFilter, global float* pOutput, const int nFilterWidth, const int nFilterHeight, const int nInMaps, global const float* pBias) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  const int ImWidth = get_global_size(0);
  const int ImHeight = get_global_size(1);

  float sum = 0;
  int c = 0;

  int idxFtmp = z * nFilterHeight * nFilterWidth * nInMaps;

  for (int maps = 0; maps < nInMaps; maps++) {
    for (int r = 0; r < nFilterHeight; r++) {
      int idxF = idxFtmp + ((maps * nFilterHeight + r) * nFilterWidth) + c;
      int idxIn = ((((maps * ImHeight) + y + r) * ImWidth) + x) + c;
      sum += pFilter[hook(1, idxF)] * pInput[hook(0, idxIn)];
      idxF++;
      idxIn++;
      sum += pFilter[hook(1, idxF)] * pInput[hook(0, idxIn)];
      idxF++;
      idxIn++;
      sum += pFilter[hook(1, idxF)] * pInput[hook(0, idxIn)];
      idxF++;
      idxIn++;
      sum += pFilter[hook(1, idxF)] * pInput[hook(0, idxIn)];
      idxF++;
      idxIn++;
      sum += pFilter[hook(1, idxF)] * pInput[hook(0, idxIn)];
      c += 5;
    }
  }
  pOutput[hook(2, (y * ImWidth) + x)] = sum + *pBias;
}