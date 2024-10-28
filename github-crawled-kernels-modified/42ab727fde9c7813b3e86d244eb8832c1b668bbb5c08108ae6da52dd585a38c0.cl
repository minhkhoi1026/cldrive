//{"argMax":4,"coef":1,"nParam":3,"tol":2,"x0":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void maxPoly(double x0, global double* coef, double tol, int nParam, global double* argMax) {
  int i = get_global_id(0);

  if (i >= nParam) {
    return;
  } else {
    double x = x0;
    double diff = tol + 1;
    double firstDeriv, secondDeriv, xNew;
    while (diff > tol) {
      firstDeriv = 2 * coef[hook(1, i)] * x + 2.3;

      secondDeriv = 2 * coef[hook(1, i)];

      xNew = x - firstDeriv / secondDeriv;

      diff = fabs(xNew - x);
      x = xNew;
    }

    argMax[hook(4, i)] = x;
  }
}