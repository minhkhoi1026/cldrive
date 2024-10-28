//{"idata":0,"ldata_ex":5,"nPad":4,"nxGlobal":2,"nyGlobal":3,"odata":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve(global float* idata, global float* odata, const unsigned int nxGlobal, const unsigned int nyGlobal, const unsigned int nPad, local float* ldata_ex) {
  const int lStride = get_local_size(0) + 2 * nPad;
  const int gStride = nxGlobal + 2 * nPad;

  const int g_ex_offset = (get_group_id(0) * get_local_size(0)) + (get_group_id(1) * get_local_size(1)) * gStride;

  const unsigned int kx = get_global_id(0);
  const unsigned int ky = get_global_id(1);

  const unsigned int ko = kx + ky * (nxGlobal);

  const unsigned int k = kx + ky * gStride;

  const unsigned int kex = kx + nPad + (ky + nPad) * gStride;

  const unsigned int kxl = get_local_id(0);
  const unsigned int kyl = get_local_id(1);

  const unsigned int kl = kxl + kyl * lStride;

  const unsigned int klex = (kxl + nPad) + (kyl + nPad) * lStride;

  if (ko < nxGlobal * nyGlobal) {
    ldata_ex[hook(5, kl)] = idata[hook(0, k)];

    if (kxl < 2 * nPad) {
      ldata_ex[hook(5, kl + get_local_size(0))] = idata[hook(0, k + get_local_size(0))];
    }

    if (kyl < 2 * nPad) {
      ldata_ex[hook(5, kl + get_local_size(1) * lStride)] = idata[hook(0, k + get_local_size(1) * gStride)];

      if (kxl < 2 * nPad) {
        ldata_ex[hook(5, kl + get_local_size(0) + get_local_size(1) * lStride)] = idata[hook(0, k + get_local_size(0) + get_local_size(1) * gStride)];
      }
    }
  }

  barrier(0x01);
  if (ko < nxGlobal * nyGlobal) {
    float sum = 0.0f;
    const int sy = get_local_size(0) + 2 * nPad;

    for (int i = 0; i < 3; i++) {
      int offset = (i - 1) * sy;

      sum += 1.1f * ldata_ex[hook(5, klex + offset - 1)] + 2.1f * ldata_ex[hook(5, klex + offset)] + 3.1f * ldata_ex[hook(5, klex + offset + 1)];
    }

    odata[hook(1, ko)] = sum;
  }
}