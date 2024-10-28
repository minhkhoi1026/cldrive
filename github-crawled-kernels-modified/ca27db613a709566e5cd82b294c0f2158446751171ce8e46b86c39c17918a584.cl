//{"ioim":0,"rr":4,"tim":1,"xx":2,"yy":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void flat(global float* ioim, global float* tim, int xx, int yy, int rr) {
  const int index = get_global_id(0);
  if (isnan(ioim[hook(0, index)]))
    return;
  const int j = index / xx;
  const int i = index % xx;

  float sum = 0;
  int tot = 0;

  const int ym = max(0, j - rr);
  const int yM = min(yy, j + rr);
  const int xm = max(0, i - rr);
  const int xM = min(xx, i + rr);
  const int rr2 = rr * rr;

  for (int y = ym; y < yM; y++) {
    const int xst = y * xx;
    const int yj2 = (y - j) * (y - j);
    for (int x = xm; x < xM; x++) {
      const float val = ioim[hook(0, x + xst)];
      if (!isnan(val) && yj2 + (x - i) * (x - i) <= rr2) {
        tot++;
        sum += val;
      }
    }
  }

  tim[hook(1, index)] = sum == 0.0 ? 1.0 : ioim[hook(0, index)] * tot / sum;
}