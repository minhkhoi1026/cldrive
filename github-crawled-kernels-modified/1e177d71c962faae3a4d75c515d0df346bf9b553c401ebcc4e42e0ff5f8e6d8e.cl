//{"A":6,"B":7,"Du":4,"Dv":5,"Kx":2,"Ky":3,"Nx":10,"Ny":11,"c":9,"dt":8,"uhat":0,"vhat":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void linearpart(global double2* uhat, global double2* vhat, global const double* Kx, global const double* Ky, const double Du, const double Dv, const double A, const double B, const double dt, const double c, const int Nx, const int Ny) {
  const int ind = get_global_id(0);

  int i, j, k;

  j = floor((double)(ind) / (double)Nx);
  i = ind - j * Nx;
  double uexp;
  double vexp;

  uexp = dt * c * (-1.0 * A + Du * (Kx[hook(2, i)] + Ky[hook(3, j)]));
  vexp = dt * c * (-1.0 * B + Dv * (Kx[hook(2, i)] + Ky[hook(3, j)]));

  uhat[hook(0, ind)].x = exp(uexp) * uhat[hook(0, ind)].x;
  uhat[hook(0, ind)].y = exp(uexp) * uhat[hook(0, ind)].y;

  vhat[hook(1, ind)].x = exp(vexp) * vhat[hook(1, ind)].x;
  vhat[hook(1, ind)].y = exp(vexp) * vhat[hook(1, ind)].y;
}