//{"RED0":5,"nFilterWidth":4,"nInWidth":3,"pFilter":1,"pInput":0,"pOutput":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float4 float4;
kernel void Convolve(const global float* pInput, constant float* pFilter, global float* pOutput, const int nInWidth, const int nFilterWidth) {
  int nWidth = get_global_size(0);

  int xOut = get_global_id(0);
  int yOut = get_global_id(1);

  int xInTopLeft = xOut;
  int yInTopLeft = yOut;

  float sum = 0;
  float RED0[4];
  int idxFtmp, yIn, idxIntmp;

  int idxOut0, r0;

l99998:
  for (r0 = 0; r0 <= nFilterWidth - 1; r0 += 1) {
    idxFtmp = r0 * nFilterWidth;

    yIn = yInTopLeft + r0;
    idxIntmp = ((xInTopLeft) + (yIn) * (nInWidth));

    int c0, c1;

    float4 vec00_0, vec10_0, vec20_0;
    vec00_0 = 0;

  l99999:
    for (c0 = 0; c0 <= 4 * ((nFilterWidth) / 4) - 1; c0 += 4) {
      vec10_0 = vload4(0, &pFilter[hook(1, idxFtmp + c0)]);
      vec20_0 = vload4(0, &pInput[hook(0, idxIntmp + c0)]);
      vec00_0 = (vec00_0) + (vec10_0) * (vec20_0);
    }
    vstore4(vec00_0, 0, &RED0[hook(5, 0)]);
    sum = sum + RED0[hook(5, 0)] + RED0[hook(5, 1)] + RED0[hook(5, 2)] + RED0[hook(5, 3)];
    for (c1 = 4 * ((nFilterWidth) / 4); c1 <= nFilterWidth - 1; c1 += 1)
      sum = ((sum) + (pFilter[hook(1, idxFtmp + c1)]) * (pInput[hook(0, idxIntmp + c1)]));
  }

  idxOut0 = ((xOut) + (yOut) * (nWidth));
  pOutput[hook(2, idxOut0)] = sum;
}