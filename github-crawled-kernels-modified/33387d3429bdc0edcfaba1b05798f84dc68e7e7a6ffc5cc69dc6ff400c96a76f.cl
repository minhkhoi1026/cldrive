//{"Pface":10,"Pface[0]":18,"Pface[0][0]":17,"Pface[0][1]":20,"Pface[0][2]":22,"Pface[1]":16,"Pface[1][0]":15,"Pface[1][1]":19,"Pface[1][2]":21,"Pface[ix]":9,"Pface[ix][0]":8,"Pface[iy]":12,"Pface[iy][1]":11,"Pface[iz]":14,"Pface[iz][2]":13,"ce":7,"ce[m]":6,"dtemp":5,"g_ce":1,"g_u":0,"gp0":2,"gp1":3,"gp2":4,"u":26,"u[k]":25,"u[k][j]":24,"u[k][j][i]":23}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void exact_solution(double xi, double eta, double zeta, double dtemp[5], constant double* g_ce) {
  int m;
  constant double(*ce)[13] = (constant double(*)[13])g_ce;

  for (m = 0; m < 5; m++) {
    dtemp[hook(5, m)] = ce[hook(7, m)][hook(6, 0)] + xi * (ce[hook(7, m)][hook(6, 1)] + xi * (ce[hook(7, m)][hook(6, 4)] + xi * (ce[hook(7, m)][hook(6, 7)] + xi * ce[hook(7, m)][hook(6, 10)]))) + eta * (ce[hook(7, m)][hook(6, 2)] + eta * (ce[hook(7, m)][hook(6, 5)] + eta * (ce[hook(7, m)][hook(6, 8)] + eta * ce[hook(7, m)][hook(6, 11)]))) + zeta * (ce[hook(7, m)][hook(6, 3)] + zeta * (ce[hook(7, m)][hook(6, 6)] + zeta * (ce[hook(7, m)][hook(6, 9)] + zeta * ce[hook(7, m)][hook(6, 12)])));
  }
}
kernel void initialize2(global double* g_u, constant double* g_ce, int gp0, int gp1, int gp2) {
  int i, j, k, m, ix, iy, iz;
  double xi, eta, zeta, Pface[2][3][5], Pxi, Peta, Pzeta;

  k = get_global_id(2);
  j = get_global_id(1);
  i = get_global_id(0);
  if (k >= gp2 || j >= gp1 || i >= gp0)
    return;

  global double(*u)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_u;

  zeta = (double)k * (1.0 / (double)(64 - 1));
  eta = (double)j * (1.0 / (double)(64 - 1));
  xi = (double)i * (1.0 / (double)(64 - 1));

  for (ix = 0; ix < 2; ix++) {
    Pxi = (double)ix;
    exact_solution(Pxi, eta, zeta, &Pface[hook(10, ix)][hook(9, 0)][hook(8, 0)], g_ce);
  }

  for (iy = 0; iy < 2; iy++) {
    Peta = (double)iy;
    exact_solution(xi, Peta, zeta, &Pface[hook(10, iy)][hook(12, 1)][hook(11, 0)], g_ce);
  }

  for (iz = 0; iz < 2; iz++) {
    Pzeta = (double)iz;
    exact_solution(xi, eta, Pzeta, &Pface[hook(10, iz)][hook(14, 2)][hook(13, 0)], g_ce);
  }

  for (m = 0; m < 5; m++) {
    Pxi = xi * Pface[hook(10, 1)][hook(16, 0)][hook(15, m)] + (1.0 - xi) * Pface[hook(10, 0)][hook(18, 0)][hook(17, m)];
    Peta = eta * Pface[hook(10, 1)][hook(16, 1)][hook(19, m)] + (1.0 - eta) * Pface[hook(10, 0)][hook(18, 1)][hook(20, m)];
    Pzeta = zeta * Pface[hook(10, 1)][hook(16, 2)][hook(21, m)] + (1.0 - zeta) * Pface[hook(10, 0)][hook(18, 2)][hook(22, m)];

    u[hook(26, k)][hook(25, j)][hook(24, i)][hook(23, m)] = Pxi + Peta + Pzeta - Pxi * Peta - Pxi * Pzeta - Peta * Pzeta + Pxi * Peta * Pzeta;
  }
}