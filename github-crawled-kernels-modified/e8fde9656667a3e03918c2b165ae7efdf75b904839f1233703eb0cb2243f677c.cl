//{"g_qs":4,"g_rho_i":5,"g_square":6,"g_u":0,"g_us":1,"g_vs":2,"g_ws":3,"gp0":7,"gp1":8,"gp2":9,"qs":31,"qs[k]":30,"qs[k][j]":29,"rho_i":16,"rho_i[k]":15,"rho_i[k][j]":14,"square":28,"square[k]":27,"square[k][j]":26,"u":13,"u[k]":12,"u[k][j]":11,"u[k][j][i]":10,"us":19,"us[k]":18,"us[k][j]":17,"vs":22,"vs[k]":21,"vs[k][j]":20,"ws":25,"ws[k]":24,"ws[k][j]":23}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rhs1(global const double* g_u, global double* g_us, global double* g_vs, global double* g_ws, global double* g_qs, global double* g_rho_i, global double* g_square, int gp0, int gp1, int gp2) {
  int i, j, k;
  double rho_inv;

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

  rho_inv = 1.0 / u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 0)];
  rho_i[hook(16, k)][hook(15, j)][hook(14, i)] = rho_inv;
  us[hook(19, k)][hook(18, j)][hook(17, i)] = u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 1)] * rho_inv;
  vs[hook(22, k)][hook(21, j)][hook(20, i)] = u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 2)] * rho_inv;
  ws[hook(25, k)][hook(24, j)][hook(23, i)] = u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 3)] * rho_inv;
  square[hook(28, k)][hook(27, j)][hook(26, i)] = 0.5 * (u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 1)] * u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 1)] + u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 2)] * u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 2)] + u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 3)] * u[hook(13, k)][hook(12, j)][hook(11, i)][hook(10, 3)]) * rho_inv;
  qs[hook(31, k)][hook(30, j)][hook(29, i)] = square[hook(28, k)][hook(27, j)][hook(26, i)] * rho_inv;
}