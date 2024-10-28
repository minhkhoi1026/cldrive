//{"d":3,"noo2sigma2":7,"np":2,"nv":6,"p":1,"v":5,"x":0,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void apply_gaussian_kernel(global double* x, global double* p, const int np, const int d, global double* y, global double* v, const int nv, const double noo2sigma2) {
  int i = get_global_id(0);
  if (i > nv)
    return;
  int di = d * i;
  for (int j = 0; j < d; ++j)
    v[hook(5, di + j)] = 0.0;
  double3 yi = (double3)(y[hook(4, di)], y[hook(4, di + 1)], y[hook(4, di + 2)]);
  double3 xj;
  int dj;
  double d2;

  for (int j = 0; j < np; ++j) {
    dj = d * j;
    xj = (double3)(x[hook(0, dj)], x[hook(0, dj + 1)], x[hook(0, dj + 2)]);

    d2 = length(yi - xj);
    d2 *= d2;
    d2 *= noo2sigma2;
    for (int k = 0; k < d; ++k) {
      v[hook(5, di + k)] += exp(d2) * p[hook(1, dj + k)];
    }
  }
}