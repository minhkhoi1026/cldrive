//{"idata":0,"ldata_ex":5,"nPad":4,"nxGlobal":2,"nyGlobal":3,"odata":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve_cpu(global float* idata, global float* odata, const unsigned int nxGlobal, const unsigned int nyGlobal, const unsigned int nPad, local float* ldata_ex) {
  const unsigned int kx = get_global_id(0);
  const unsigned int ky = get_global_id(1);
  const unsigned int k = kx + ky * nxGlobal;

  const unsigned int kex = (kx + nPad) + (ky + nPad) * (nxGlobal + 2 * nPad);

  if (k < nxGlobal * nyGlobal) {
    float sum = 0.0f;
    const int sy = nxGlobal + 2 * nPad;

    for (int i = 0; i < 3; i++) {
      int offset = (i - 1) * sy;
      sum += 1.1f * idata[hook(0, kex + offset - 1)] + 2.1f * idata[hook(0, kex + offset)] + 3.1f * idata[hook(0, kex + offset + 1)];
    }
    odata[hook(1, k)] = sum;
  }
}