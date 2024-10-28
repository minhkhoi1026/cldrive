//{"dst":6,"point":7,"points":5,"sizeRows":3,"sizeZcols":4,"x":1,"y":0,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void log_iv_density(global const float* y, global const float* x, global const float* z, int sizeRows, int sizeZcols, global const float* points, global float* dst) {
  int pIndex = get_global_id(0);
  int pointSize = sizeZcols + 4;

  global const float* point = points + (pointSize * pIndex);

  float beta = point[hook(7, 0)];
  float omega11 = point[hook(7, pointSize - 3)];
  float omega22 = point[hook(7, pointSize - 2)];
  float rho = point[hook(7, pointSize - 1)];

  float BIVARDEN1STTERM = -(2.0f / 2.0f) * native_log(2.0f * 3.141592654f);

  if (omega11 <= 0.0f || omega22 <= 0.0f || rho < -1.0f || rho > 1.0f) {
    dst[hook(6, pIndex)] = -(__builtin_inff());
    return;
  }

  float Om121 = rho * native_sqrt(omega11 * omega22);
  float omegaDet = (omega11 * omega22) - (Om121 * Om121);
  float omegaInv11 = omega22 / omegaDet;
  float omegaInv121 = -Om121 / omegaDet;
  float omegaInv22 = omega11 / omegaDet;

  float res = (-3.0f / 2.0f) * native_log(omegaDet);

  float bivarfirst2terms = BIVARDEN1STTERM - 0.5f * native_log(omegaDet);

  for (int i = 0; i < sizeRows; i++) {
    float mean1 = y[hook(0, i)] - x[hook(1, i)] * beta;
    float mean2 = x[hook(1, i)];
    for (int j = 0; j < sizeZcols; j++) {
      mean2 -= point[hook(7, j + 1)] * z[hook(2, i * sizeZcols + j)];
    }

    float mults = ((mean1 * omegaInv11 + mean2 * omegaInv121) * mean1) + ((mean1 * omegaInv121 + mean2 * omegaInv22) * mean2);
    float dens = bivarfirst2terms - 0.5 * mults;
    res += dens;
  }

  dst[hook(6, pIndex)] = res;
}