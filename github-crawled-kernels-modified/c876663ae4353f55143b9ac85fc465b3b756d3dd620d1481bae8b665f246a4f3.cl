//{"ce":7,"ce[m]":6,"dtemp":5,"g_ce":1,"g_u":0,"gp0":2,"gp1":3,"gp2":4,"temp":12,"u":11,"u[k]":10,"u[k][j]":9,"u[k][j][i]":8}
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
kernel void initialize3(global double* g_u, constant double* g_ce, int gp0, int gp1, int gp2) {
  int i, j, k, m;
  double xi, eta, zeta, temp[5];

  k = get_global_id(1);
  j = get_global_id(0);
  if (k >= gp2 || j >= gp1)
    return;

  global double(*u)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_u;

  zeta = (double)k * (1.0 / (double)(64 - 1));
  eta = (double)j * (1.0 / (double)(64 - 1));

  xi = 0.0;
  i = 0;
  exact_solution(xi, eta, zeta, temp, g_ce);
  for (m = 0; m < 5; m++) {
    u[hook(11, k)][hook(10, j)][hook(9, i)][hook(8, m)] = temp[hook(12, m)];
  }

  xi = 1.0;
  i = gp0 - 1;
  exact_solution(xi, eta, zeta, temp, g_ce);
  for (m = 0; m < 5; m++) {
    u[hook(11, k)][hook(10, j)][hook(9, i)][hook(8, m)] = temp[hook(12, m)];
  }
}