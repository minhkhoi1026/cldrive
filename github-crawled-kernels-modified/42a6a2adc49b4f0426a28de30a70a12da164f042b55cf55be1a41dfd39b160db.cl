//{"iHeight":3,"iWidth":2,"nPoolsize":4,"nStride":5,"pInput":0,"pOutput":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxpool3D(const global float* pInput, global float* pOutput, const int iWidth, const int iHeight, const int nPoolsize, const int nStride) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  const int oWidth = get_global_size(0);
  const int oHeight = get_global_size(1);

  const int xidx = nStride * x;
  const int yidx = nStride * y;
  float maxval = 0.0;
  for (int r = 0; r < nPoolsize; r++) {
    const int idxIntmp = (((z * iHeight) + yidx + r) * iWidth) + xidx;
    for (int c = 0; c < nPoolsize; c++) {
      const int idxIn = idxIntmp + c;
      maxval = fmax(maxval, pInput[hook(0, idxIn)]);
    }
  }
  pOutput[hook(1, (((z * oHeight) + y) * oWidth) + x)] = maxval;
}