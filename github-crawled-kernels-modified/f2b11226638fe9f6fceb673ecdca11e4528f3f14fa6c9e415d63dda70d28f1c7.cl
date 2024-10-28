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

  float maxval = -3.402823e+37;
  int hstart = y * nStride;
  int wstart = x * nStride;

  int hend = hstart + nPoolsize;
  int wend = wstart + nPoolsize;
  for (unsigned int r = hstart; r < hend; r++) {
    for (unsigned int c = wstart; c < wend; c++) {
      unsigned int idx = z * iHeight * iWidth + r * iWidth + c;
      maxval = fmax(maxval, pInput[hook(0, idx)]);
    }
  }
  pOutput[hook(1, (((z * oHeight) + y) * oWidth) + x)] = maxval;
}