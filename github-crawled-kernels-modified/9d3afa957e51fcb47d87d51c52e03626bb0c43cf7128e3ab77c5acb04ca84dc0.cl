//{"ce":6,"ce[m]":5,"dtemp":4,"forcing":10,"forcing[k]":9,"forcing[k][j]":8,"forcing[k][j][i]":7,"g_forcing":0,"gp0":1,"gp1":2,"gp2":3}
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

kernel void exact_rhs5(global double* g_forcing, int gp0, int gp1, int gp2) {
  int k = get_global_id(2) + 1;
  int j = get_global_id(1) + 1;
  int i = get_global_id(0) + 1;
  if (k > (gp2 - 2) || j > (gp1 - 2) || i > (gp0 - 2))
    return;

  int m;
  global double(*forcing)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_forcing;

  for (m = 0; m < 5; m++) {
    forcing[hook(10, k)][hook(9, j)][hook(8, i)][hook(7, m)] = -1.0 * forcing[hook(10, k)][hook(9, j)][hook(8, i)][hook(7, m)];
  }
}