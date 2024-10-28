//{"ce":6,"ce[m]":5,"dtemp":4,"g_u":0,"gp0":1,"gp1":2,"gp2":3,"u":10,"u[k]":9,"u[k][j]":8,"u[k][j][i]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void exact_solution(double xi, double eta, double zeta, double dtemp[5], constant double* g_ce) {
  int m;
  constant double(*ce)[13] = (constant double(*)[13])g_ce;

  for (m = 0; m < 5; m++) {
    dtemp[hook(4, m)] = ce[hook(6, m)][hook(5, 0)] + xi * (ce[hook(6, m)][hook(5, 1)] + xi * (ce[hook(6, m)][hook(5, 4)] + xi * (ce[hook(6, m)][hook(5, 7)] + xi * ce[hook(6, m)][hook(5, 10)]))) + eta * (ce[hook(6, m)][hook(5, 2)] + eta * (ce[hook(6, m)][hook(5, 5)] + eta * (ce[hook(6, m)][hook(5, 8)] + eta * ce[hook(6, m)][hook(5, 11)]))) + zeta * (ce[hook(6, m)][hook(5, 3)] + zeta * (ce[hook(6, m)][hook(5, 6)] + zeta * (ce[hook(6, m)][hook(5, 9)] + zeta * ce[hook(6, m)][hook(5, 12)])));
  }
}
kernel void initialize1(global double* g_u, int gp0, int gp1, int gp2) {
  int k = get_global_id(1);
  int j = get_global_id(0);
  if (k >= gp2 || j >= gp1)
    return;

  int i;
  global double(*u)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_u;

  for (i = 0; i < gp0; i++) {
    u[hook(10, k)][hook(9, j)][hook(8, i)][hook(7, 0)] = 1.0;
    u[hook(10, k)][hook(9, j)][hook(8, i)][hook(7, 1)] = 0.0;
    u[hook(10, k)][hook(9, j)][hook(8, i)][hook(7, 2)] = 0.0;
    u[hook(10, k)][hook(9, j)][hook(8, i)][hook(7, 3)] = 0.0;
    u[hook(10, k)][hook(9, j)][hook(8, i)][hook(7, 4)] = 1.0;
  }
}