//{"dst":6,"point":7,"points":5,"sizeRows":4,"sizeZcols":3,"x":1,"y":0,"z":2,"zi":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void log_iv_density_v2(global const float* y, global const float* x, global const float* z, int sizeZcols, int sizeRows, global const float* points, global float* dst) {
  int dataIndex = get_global_id(0);
  int pointIndex = get_global_id(1);

  int pointSize = sizeZcols + 4;

  global const float* point = points + (pointSize * pointIndex);
  float yi = y[hook(0, dataIndex)];
  float xi = x[hook(1, dataIndex)];
  global const float* zi = z + (dataIndex * sizeZcols);
  global float* dest = dst + dataIndex + (pointIndex * sizeRows);

  float beta = point[hook(7, 0)];
  float omega11 = point[hook(7, pointSize - 3)];
  float omega22 = point[hook(7, pointSize - 2)];
  float rho = point[hook(7, pointSize - 1)];

  float BIVARDEN1STTERM = -(2.0f / 2.0f) * native_log(2.0f * 3.141592654f);

  if (omega11 <= 0.0f || omega22 <= 0.0f || rho < -1.0f || rho > 1.0f) {
    *dest = -(__builtin_inff());
    return;
  }

  float Om121 = rho * native_sqrt(omega11 * omega22);
  float omegaDet = (omega11 * omega22) - (Om121 * Om121);
  float omegaInv11 = omega22 / omegaDet;
  float omegaInv121 = -Om121 / omegaDet;
  float omegaInv22 = omega11 / omegaDet;

  float bivarfirst2terms = BIVARDEN1STTERM - 0.5f * native_log(omegaDet);

  float mean1 = yi - xi * beta;
  float mean2 = xi;

  for (int j = 0; j < sizeZcols; j++) {
    mean2 -= point[hook(7, j + 1)] * zi[hook(8, j)];
  }

  float mults = ((mean1 * omegaInv11 + mean2 * omegaInv121) * mean1) + ((mean1 * omegaInv121 + mean2 * omegaInv22) * mean2);
  float dens = bivarfirst2terms - 0.5f * mults;

  *dest = dens;
}