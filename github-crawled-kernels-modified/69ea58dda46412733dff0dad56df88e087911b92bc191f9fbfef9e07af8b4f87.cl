//{"Hstride":6,"ImHeight":5,"ImWidth":4,"PoolHeight":3,"PoolWidth":2,"Vstride":7,"pInput":0,"pOutput":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxpool2D(const global float* pInput, global float* pOutput, const int PoolWidth, const int PoolHeight, const int ImWidth, const int ImHeight, const int Hstride, const int Vstride) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int xidx = Hstride * x;
  const int yidx = Vstride * y;
  float maxval = 0.0;
  for (int r = 0; r < PoolHeight; r++) {
    const int idxIntmp = ((yidx + r) * ImWidth) + xidx;
    for (int c = 0; c < PoolWidth; c++) {
      const int idxIn = idxIntmp + c;
      maxval = fmax(maxval, pInput[hook(0, idxIn)]);
    }
  }
  pOutput[hook(1, (y * ImWidth) + x)] = maxval;
}