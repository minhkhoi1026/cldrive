//{"nFilterHeight":4,"nFilterWidth":3,"nInMaps":5,"pBias":6,"pFilter":1,"pInput":0,"pOutput":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter3D(const global float* pInput, const global float* pFilter, global float* pOutput, const int nFilterWidth, const int nFilterHeight, const int nInMaps, const global float* pBias) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  const int OWidth = get_global_size(0);
  const int OHeight = get_global_size(1);
  const int ImWidth = OWidth + nFilterWidth - 1;
  const int ImHeight = OHeight + nFilterHeight - 1;
  float4 sum4 = 0;
  int idxFstart = z * nFilterHeight * nFilterWidth * nInMaps;

  for (int maps = 0; maps < nInMaps; maps++) {
    for (int r = 0; r < nFilterHeight; r++) {
      const int idxFtmp = idxFstart + (maps * nFilterHeight + r) * nFilterWidth;
      const int idxIntmp = (((maps * ImHeight) + y + r) * ImWidth) + x;
      int c = 0;
      int c4 = 0;
      while (c <= nFilterWidth - 4) {
        float4 filter4 = vload4(c4, pFilter + idxFtmp);
        float4 in4 = vload4(c4, pInput + idxIntmp);
        sum4 += in4 * filter4;
        c += 4;
        c4++;
      }
      for (int c1 = c; c1 < nFilterWidth; c1++) {
        const int idxF = idxFtmp + c1;
        const int idxIn = idxIntmp + c1;
        sum4.x += pFilter[hook(1, idxF)] * pInput[hook(0, idxIn)];
      }
    }
  }
  pOutput[hook(2, ((z * OHeight * OWidth) + (y * OWidth) + x))] = sum4.x + sum4.y + sum4.z + sum4.w + pBias[hook(6, z)];
}