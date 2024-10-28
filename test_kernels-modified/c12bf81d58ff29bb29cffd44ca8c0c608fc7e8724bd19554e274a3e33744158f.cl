//{"colourPeriod":8,"maxIters":7,"pixels":0,"xMax":4,"xMin":3,"xRes":1,"yMax":6,"yMin":5,"yRes":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void renderMandelbrotKernel(global float* restrict pixels, const int xRes, const int yRes, const double xMin, const double xMax, const double yMin, const double yMax, const int maxIters, const double colourPeriod) {
  const int x = get_global_id(0) % xRes;
  const int y = get_global_id(0) / xRes;

  int iter = 0;

  double u = 0.0, v = 0.0, uNew, vNew;
  double uSq = 0.0, vSq = 0.0;
  const double xPix = ((double)x / (double)xRes);
  const double yPix = ((double)y / (double)yRes);
  const double Rec = (1.0 - xPix) * xMin + xPix * xMax;
  const double Imc = (1.0 - yPix) * yMin + yPix * yMax;

  const double RecSq = Rec * Rec;
  const double ImcSq = Imc * Imc;
  const double q = (RecSq - 0.5 * Rec + 0.125) + ImcSq;
  if ((q * (q + (Rec - 0.25)) < (ImcSq * 0.25)) || ((RecSq + 2.0 * Rec + 1.0) + ImcSq < 1.0 / 16.0)) {
    iter = maxIters;
  }

  while ((uSq + vSq) <= 4.0 && iter < maxIters) {
    uNew = uSq - vSq + Rec;
    uSq = uNew * uNew;
    vNew = 2.0 * u * v + Imc;
    vSq = vNew * vNew;
    u = uNew;
    v = vNew;
    iter++;
  }

  float r, g, b;

  if (iter == maxIters) {
    r = 0.0;
    g = 0.0;
    b = 0.0;
  }

  else {
    float smooth = fmod((iter - log(log(uSq + vSq) / log(2.0f))), colourPeriod) / colourPeriod;

    if (smooth < 0.25) {
      r = 0.0;
      g = 0.5 * smooth * 4.0;
      b = 1.0 * smooth * 4.0;
    } else if (smooth < 0.5) {
      r = 1.0 * (smooth - 0.25) * 4.0;
      g = 0.5 + 0.5 * (smooth - 0.25) * 4.0;
      b = 1.0;
    } else if (smooth < 0.75) {
      r = 1.0;
      g = 1.0 - 0.5 * (smooth - 0.5) * 4.0;
      b = 1.0 - (smooth - 0.5) * 4.0;
    } else {
      r = (1.0 - (smooth - 0.75) * 4.0);
      g = 0.5 * (1.0 - (smooth - 0.75) * 4.0);
      b = 0.0;
    }
  }

  pixels[hook(0, y * xRes * 3 + x * 3 + 0)] = r;
  pixels[hook(0, y * xRes * 3 + x * 3 + 1)] = g;
  pixels[hook(0, y * xRes * 3 + x * 3 + 2)] = b;
}