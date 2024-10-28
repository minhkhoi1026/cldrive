//{"g_qs":4,"g_rho_i":5,"g_rhs":7,"g_square":6,"g_u":0,"g_us":1,"g_vs":2,"g_ws":3,"gp0":8,"gp1":9,"gp2":10,"qs":53,"qs[k + 1]":52,"qs[k + 1][j]":51,"qs[k - 1]":57,"qs[k - 1][j]":56,"qs[k]":55,"qs[k][j]":54,"rho_i":60,"rho_i[k + 1]":59,"rho_i[k + 1][j]":58,"rho_i[k - 1]":64,"rho_i[k - 1][j]":63,"rho_i[k]":62,"rho_i[k][j]":61,"rhs":21,"rhs[k]":20,"rhs[k][j]":19,"rhs[k][j][i]":18,"square":48,"square[k + 1]":47,"square[k + 1][j]":46,"square[k - 1]":50,"square[k - 1][j]":49,"u":25,"u[k + 1]":24,"u[k + 1][j]":23,"u[k + 1][j][i]":22,"u[k + 2]":67,"u[k + 2][j]":66,"u[k + 2][j][i]":65,"u[k - 1]":31,"u[k - 1][j]":30,"u[k - 1][j][i]":29,"u[k - 2]":70,"u[k - 2][j]":69,"u[k - 2][j][i]":68,"u[k]":28,"u[k][j]":27,"u[k][j][i]":26,"us":34,"us[k + 1]":33,"us[k + 1][j]":32,"us[k - 1]":38,"us[k - 1][j]":37,"us[k]":36,"us[k][j]":35,"vs":41,"vs[k + 1]":40,"vs[k + 1][j]":39,"vs[k - 1]":45,"vs[k - 1][j]":44,"vs[k]":43,"vs[k][j]":42,"ws":13,"ws[k + 1]":15,"ws[k + 1][j]":14,"ws[k - 1]":17,"ws[k - 1][j]":16,"ws[k]":12,"ws[k][j]":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rhs5(global const double* g_u, global const double* g_us, global const double* g_vs, global const double* g_ws, global const double* g_qs, global const double* g_rho_i, global const double* g_square, global double* g_rhs, int gp0, int gp1, int gp2) {
  int i, j, k, m;
  double wijk, wp1, wm1;

  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (j > (gp1 - 2) || i > (gp0 - 2))
    return;

  global double(*us)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_us;
  global double(*vs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_vs;
  global double(*ws)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_ws;
  global double(*qs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_qs;
  global double(*rho_i)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_rho_i;
  global double(*square)[64 / 2 * 2 + 1][64 / 2 * 2 + 1] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1]) g_square;
  global double(*u)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_u;
  global double(*rhs)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5] = (global double(*)[64 / 2 * 2 + 1][64 / 2 * 2 + 1][5]) g_rhs;

  for (k = 1; k <= gp2 - 2; k++) {
    wijk = ws[hook(13, k)][hook(12, j)][hook(11, i)];
    wp1 = ws[hook(13, k + 1)][hook(15, j)][hook(14, i)];
    wm1 = ws[hook(13, k - 1)][hook(17, j)][hook(16, i)];

    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 0)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 0)] + (1.0 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 0)] - 2.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, 0)] + u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 0)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 3)] - u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 3)]);
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 1)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 1)] + (1.0 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 1)] - 2.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, 1)] + u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 1)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (us[hook(34, k + 1)][hook(33, j)][hook(32, i)] - 2.0 * us[hook(34, k)][hook(36, j)][hook(35, i)] + us[hook(34, k - 1)][hook(38, j)][hook(37, i)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 1)] * wp1 - u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 1)] * wm1);
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 2)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 2)] + (1.0 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 2)] - 2.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, 2)] + u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 2)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (vs[hook(41, k + 1)][hook(40, j)][hook(39, i)] - 2.0 * vs[hook(41, k)][hook(43, j)][hook(42, i)] + vs[hook(41, k - 1)][hook(45, j)][hook(44, i)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 2)] * wp1 - u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 2)] * wm1);
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 3)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 3)] + (1.0 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 3)] - 2.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, 3)] + u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 3)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (4.0 / 3.0) * (wp1 - 2.0 * wijk + wm1) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 3)] * wp1 - u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 3)] * wm1 + (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 4)] - square[hook(48, k + 1)][hook(47, j)][hook(46, i)] - u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 4)] + square[hook(48, k - 1)][hook(50, j)][hook(49, i)]) * 0.4);
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 4)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, 4)] + (1.0 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 4)] - 2.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, 4)] + u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 4)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 - (1.4 * 1.4)) * (1.0 / (1.0 / (double)(64 - 1)))) * (qs[hook(53, k + 1)][hook(52, j)][hook(51, i)] - 2.0 * qs[hook(53, k)][hook(55, j)][hook(54, i)] + qs[hook(53, k - 1)][hook(57, j)][hook(56, i)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / 6.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (wp1 * wp1 - 2.0 * wijk * wijk + wm1 * wm1) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.4 * 1.4) * (1.0 / (1.0 / (double)(64 - 1)))) * (u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 4)] * rho_i[hook(60, k + 1)][hook(59, j)][hook(58, i)] - 2.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, 4)] * rho_i[hook(60, k)][hook(62, j)][hook(61, i)] + u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 4)] * rho_i[hook(60, k - 1)][hook(64, j)][hook(63, i)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * ((1.4 * u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, 4)] - 0.4 * square[hook(48, k + 1)][hook(47, j)][hook(46, i)]) * wp1 - (1.4 * u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, 4)] - 0.4 * square[hook(48, k - 1)][hook(50, j)][hook(49, i)]) * wm1);
  }

  k = 1;
  for (m = 0; m < 5; m++) {
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (5.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, m)] - 4.0 * u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, m)] + u[hook(25, k + 2)][hook(67, j)][hook(66, i)][hook(65, m)]);
  }

  k = 2;
  for (m = 0; m < 5; m++) {
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (-4.0 * u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, m)] + 6.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, m)] - 4.0 * u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, m)] + u[hook(25, k + 2)][hook(67, j)][hook(66, i)][hook(65, m)]);
  }

  for (k = 3; k <= gp2 - 4; k++) {
    for (m = 0; m < 5; m++) {
      rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(25, k - 2)][hook(70, j)][hook(69, i)][hook(68, m)] - 4.0 * u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, m)] + 6.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, m)] - 4.0 * u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, m)] + u[hook(25, k + 2)][hook(67, j)][hook(66, i)][hook(65, m)]);
    }
  }

  k = gp2 - 3;
  for (m = 0; m < 5; m++) {
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(25, k - 2)][hook(70, j)][hook(69, i)][hook(68, m)] - 4.0 * u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, m)] + 6.0 * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, m)] - 4.0 * u[hook(25, k + 1)][hook(24, j)][hook(23, i)][hook(22, m)]);
  }

  k = gp2 - 2;
  for (m = 0; m < 5; m++) {
    rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] = rhs[hook(21, k)][hook(20, j)][hook(19, i)][hook(18, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(25, k - 2)][hook(70, j)][hook(69, i)][hook(68, m)] - 4. * u[hook(25, k - 1)][hook(31, j)][hook(30, i)][hook(29, m)] + 5. * u[hook(25, k)][hook(28, j)][hook(27, i)][hook(26, m)]);
  }
}