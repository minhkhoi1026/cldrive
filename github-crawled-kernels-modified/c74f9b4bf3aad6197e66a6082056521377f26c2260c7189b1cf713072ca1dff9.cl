//{"g_qs":4,"g_rho_i":5,"g_square":6,"g_u":0,"g_us":1,"g_vs":2,"g_ws":3,"gp0":7,"gp1":8,"gp2":9,"p_u":10,"qs":32,"qs[k]":31,"qs[k][j]":30,"rho_i":17,"rho_i[k]":16,"rho_i[k][j]":15,"square":29,"square[k]":28,"square[k][j]":27,"u":14,"u[k]":13,"u[k][j]":12,"u[k][j][i]":11,"us":20,"us[k]":19,"us[k][j]":18,"vs":23,"vs[k]":22,"vs[k][j]":21,"ws":26,"ws[k]":25,"ws[k][j]":24}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rhs1(global const double* g_u, global double* g_us, global double* g_vs, global double* g_ws, global double* g_qs, global double* g_rho_i, global double* g_square, int gp0, int gp1, int gp2) {
  int i, j, k;
  double rho_inv;
  double p_u[4];
  double p_square;

  k = get_global_id(2);
  j = get_global_id(1);
  i = get_global_id(0);
  if (k >= gp2 || j >= gp1 || i >= gp0)
    return;

  global double(*u)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_u;
  global double(*us)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_us;
  global double(*vs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_vs;
  global double(*ws)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_ws;
  global double(*qs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_qs;
  global double(*rho_i)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_rho_i;
  global double(*square)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_square;

  p_u[hook(10, 0)] = u[hook(14, k)][hook(13, j)][hook(12, i)][hook(11, 0)];
  p_u[hook(10, 1)] = u[hook(14, k)][hook(13, j)][hook(12, i)][hook(11, 1)];
  p_u[hook(10, 2)] = u[hook(14, k)][hook(13, j)][hook(12, i)][hook(11, 2)];
  p_u[hook(10, 3)] = u[hook(14, k)][hook(13, j)][hook(12, i)][hook(11, 3)];

  rho_inv = 1.0 / p_u[hook(10, 0)];
  rho_i[hook(17, k)][hook(16, j)][hook(15, i)] = rho_inv;
  us[hook(20, k)][hook(19, j)][hook(18, i)] = p_u[hook(10, 1)] * rho_inv;
  vs[hook(23, k)][hook(22, j)][hook(21, i)] = p_u[hook(10, 2)] * rho_inv;
  ws[hook(26, k)][hook(25, j)][hook(24, i)] = p_u[hook(10, 3)] * rho_inv;
  p_square = 0.5 * (p_u[hook(10, 1)] * p_u[hook(10, 1)] + p_u[hook(10, 2)] * p_u[hook(10, 2)] + p_u[hook(10, 3)] * p_u[hook(10, 3)]) * rho_inv;
  square[hook(29, k)][hook(28, j)][hook(27, i)] = p_square;
  qs[hook(32, k)][hook(31, j)][hook(30, i)] = p_square * rho_inv;
}