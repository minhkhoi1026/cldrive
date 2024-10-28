//{"g_qs":4,"g_rho_i":5,"g_rhs":7,"g_square":6,"g_u":0,"g_us":1,"g_vs":2,"g_ws":3,"gp0":8,"gp1":9,"gp2":10,"qs":44,"qs[k]":43,"qs[k][j + 1]":42,"qs[k][j - 1]":46,"qs[k][j]":45,"rho_i":49,"rho_i[k]":48,"rho_i[k][j + 1]":47,"rho_i[k][j - 1]":51,"rho_i[k][j]":50,"rhs":19,"rhs[k]":18,"rhs[k][j]":17,"rhs[k][j][i]":16,"square":35,"square[k]":34,"square[k][j + 1]":33,"square[k][j - 1]":36,"u":23,"u[k]":22,"u[k][j + 1]":21,"u[k][j + 1][i]":20,"u[k][j + 2]":53,"u[k][j + 2][i]":52,"u[k][j - 1]":27,"u[k][j - 1][i]":26,"u[k][j - 2]":55,"u[k][j - 2][i]":54,"u[k][j]":25,"u[k][j][i]":24,"us":30,"us[k]":29,"us[k][j + 1]":28,"us[k][j - 1]":32,"us[k][j]":31,"vs":13,"vs[k]":12,"vs[k][j + 1]":14,"vs[k][j - 1]":15,"vs[k][j]":11,"ws":39,"ws[k]":38,"ws[k][j + 1]":37,"ws[k][j - 1]":41,"ws[k][j]":40}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rhs4(global const double* g_u, global const double* g_us, global const double* g_vs, global const double* g_ws, global const double* g_qs, global const double* g_rho_i, global const double* g_square, global double* g_rhs, int gp0, int gp1, int gp2) {
  int i, j, k, m;
  double vijk, vp1, vm1;

  k = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > (gp2 - 2) || i > (gp0 - 2))
    return;

  global double(*us)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_us;
  global double(*vs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_vs;
  global double(*ws)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_ws;
  global double(*qs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_qs;
  global double(*rho_i)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_rho_i;
  global double(*square)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_square;
  global double(*u)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_u;
  global double(*rhs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_rhs;

  for (j = 1; j <= gp1 - 2; j++) {
    vijk = vs[hook(13, k)][hook(12, j)][hook(11, i)];
    vp1 = vs[hook(13, k)][hook(12, j + 1)][hook(14, i)];
    vm1 = vs[hook(13, k)][hook(12, j - 1)][hook(15, i)];
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 0)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 0)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 0)] - 2.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, 0)] + u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 0)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 2)] - u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 2)]);
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 1)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 1)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 1)] - 2.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, 1)] + u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 1)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (us[hook(30, k)][hook(29, j + 1)][hook(28, i)] - 2.0 * us[hook(30, k)][hook(29, j)][hook(31, i)] + us[hook(30, k)][hook(29, j - 1)][hook(32, i)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 1)] * vp1 - u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 1)] * vm1);
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 2)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 2)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 2)] - 2.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, 2)] + u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 2)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (4.0 / 3.0) * (vp1 - 2.0 * vijk + vm1) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 2)] * vp1 - u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 2)] * vm1 + (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 4)] - square[hook(35, k)][hook(34, j + 1)][hook(33, i)] - u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 4)] + square[hook(35, k)][hook(34, j - 1)][hook(36, i)]) * 0.4);
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 3)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 3)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 3)] - 2.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, 3)] + u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 3)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (ws[hook(39, k)][hook(38, j + 1)][hook(37, i)] - 2.0 * ws[hook(39, k)][hook(38, j)][hook(40, i)] + ws[hook(39, k)][hook(38, j - 1)][hook(41, i)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 3)] * vp1 - u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 3)] * vm1);
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 4)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, 4)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 4)] - 2.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, 4)] + u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 4)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 - (1.4 * 1.4)) * (1.0 / (1.0 / (double)(64 - 1)))) * (qs[hook(44, k)][hook(43, j + 1)][hook(42, i)] - 2.0 * qs[hook(44, k)][hook(43, j)][hook(45, i)] + qs[hook(44, k)][hook(43, j - 1)][hook(46, i)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / 6.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (vp1 * vp1 - 2.0 * vijk * vijk + vm1 * vm1) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.4 * 1.4) * (1.0 / (1.0 / (double)(64 - 1)))) * (u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 4)] * rho_i[hook(49, k)][hook(48, j + 1)][hook(47, i)] - 2.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, 4)] * rho_i[hook(49, k)][hook(48, j)][hook(50, i)] + u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 4)] * rho_i[hook(49, k)][hook(48, j - 1)][hook(51, i)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * ((1.4 * u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, 4)] - 0.4 * square[hook(35, k)][hook(34, j + 1)][hook(33, i)]) * vp1 - (1.4 * u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, 4)] - 0.4 * square[hook(35, k)][hook(34, j - 1)][hook(36, i)]) * vm1);
  }

  j = 1;
  for (m = 0; m < 5; m++) {
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (5.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, m)] - 4.0 * u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, m)] + u[hook(23, k)][hook(22, j + 2)][hook(53, i)][hook(52, m)]);
  }

  j = 2;
  for (m = 0; m < 5; m++) {
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (-4.0 * u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, m)] + 6.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, m)] - 4.0 * u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, m)] + u[hook(23, k)][hook(22, j + 2)][hook(53, i)][hook(52, m)]);
  }

  for (j = 3; j <= gp1 - 4; j++) {
    for (m = 0; m < 5; m++) {
      rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(23, k)][hook(22, j - 2)][hook(55, i)][hook(54, m)] - 4.0 * u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, m)] + 6.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, m)] - 4.0 * u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, m)] + u[hook(23, k)][hook(22, j + 2)][hook(53, i)][hook(52, m)]);
    }
  }

  j = gp1 - 3;
  for (m = 0; m < 5; m++) {
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(23, k)][hook(22, j - 2)][hook(55, i)][hook(54, m)] - 4.0 * u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, m)] + 6.0 * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, m)] - 4.0 * u[hook(23, k)][hook(22, j + 1)][hook(21, i)][hook(20, m)]);
  }

  j = gp1 - 2;
  for (m = 0; m < 5; m++) {
    rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] = rhs[hook(19, k)][hook(18, j)][hook(17, i)][hook(16, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(23, k)][hook(22, j - 2)][hook(55, i)][hook(54, m)] - 4. * u[hook(23, k)][hook(22, j - 1)][hook(27, i)][hook(26, m)] + 5. * u[hook(23, k)][hook(22, j)][hook(25, i)][hook(24, m)]);
  }
}