//{"g_qs":4,"g_rho_i":5,"g_rhs":7,"g_square":6,"g_u":0,"g_us":1,"g_vs":2,"g_ws":3,"nx2":8,"ny2":9,"nz2":10,"qs":35,"qs[k]":34,"qs[k][j]":33,"rho_i":38,"rho_i[k]":37,"rho_i[k][j]":36,"rhs":17,"rhs[k]":16,"rhs[k][j]":15,"rhs[k][j][i]":14,"square":26,"square[k]":25,"square[k][j]":24,"u":21,"u[k]":20,"u[k][j]":19,"u[k][j][i + 1]":18,"u[k][j][i + 2]":39,"u[k][j][i - 1]":23,"u[k][j][i - 2]":40,"u[k][j][i]":22,"us":13,"us[k]":12,"us[k][j]":11,"vs":29,"vs[k]":28,"vs[k][j]":27,"ws":32,"ws[k]":31,"ws[k][j]":30}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_rhs3(global const double* g_u, global const double* g_us, global const double* g_vs, global const double* g_ws, global const double* g_qs, global const double* g_rho_i, global const double* g_square, global double* g_rhs, int nx2, int ny2, int nz2) {
  int i, j, k, m;
  double uijk, up1, um1;

  k = get_global_id(1) + 1;
  j = get_global_id(0) + 1;
  if (k > nz2 || j > ny2)
    return;

  global double(*u)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_u;
  global double(*us)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_us;
  global double(*vs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_vs;
  global double(*ws)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_ws;
  global double(*qs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_qs;
  global double(*rho_i)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_rho_i;
  global double(*square)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_square;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  for (i = 1; i <= nx2; i++) {
    uijk = us[hook(13, k)][hook(12, j)][hook(11, i)];
    up1 = us[hook(13, k)][hook(12, j)][hook(11, i + 1)];
    um1 = us[hook(13, k)][hook(12, j)][hook(11, i - 1)];

    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 0)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 0)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 0)] - 2.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, 0)] + u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 0)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 1)] - u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 1)]);

    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 1)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 1)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 1)] - 2.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, 1)] + u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 1)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (4.0 / 3.0) * (up1 - 2.0 * uijk + um1) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 1)] * up1 - u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 1)] * um1 + (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 4)] - square[hook(26, k)][hook(25, j)][hook(24, i + 1)] - u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 4)] + square[hook(26, k)][hook(25, j)][hook(24, i - 1)]) * 0.4);

    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 2)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 2)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 2)] - 2.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, 2)] + u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 2)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (vs[hook(29, k)][hook(28, j)][hook(27, i + 1)] - 2.0 * vs[hook(29, k)][hook(28, j)][hook(27, i)] + vs[hook(29, k)][hook(28, j)][hook(27, i - 1)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 2)] * up1 - u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 2)] * um1);

    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 3)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 3)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 3)] - 2.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, 3)] + u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 3)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / (1.0 / (double)(64 - 1)))) * (ws[hook(32, k)][hook(31, j)][hook(30, i + 1)] - 2.0 * ws[hook(32, k)][hook(31, j)][hook(30, i)] + ws[hook(32, k)][hook(31, j)][hook(30, i - 1)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 3)] * up1 - u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 3)] * um1);

    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 4)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, 4)] + (0.75 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 4)] - 2.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, 4)] + u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 4)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 - (1.4 * 1.4)) * (1.0 / (1.0 / (double)(64 - 1)))) * (qs[hook(35, k)][hook(34, j)][hook(33, i + 1)] - 2.0 * qs[hook(35, k)][hook(34, j)][hook(33, i)] + qs[hook(35, k)][hook(34, j)][hook(33, i - 1)]) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.0 / 6.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (up1 * up1 - 2.0 * uijk * uijk + um1 * um1) + (((0.1 * 1.0) * (1.0 / (1.0 / (double)(64 - 1)))) * (1.4 * 1.4) * (1.0 / (1.0 / (double)(64 - 1)))) * (u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 4)] * rho_i[hook(38, k)][hook(37, j)][hook(36, i + 1)] - 2.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, 4)] * rho_i[hook(38, k)][hook(37, j)][hook(36, i)] + u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 4)] * rho_i[hook(38, k)][hook(37, j)][hook(36, i - 1)]) - (1.0 / (2.0 * (1.0 / (double)(64 - 1)))) * ((1.4 * u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, 4)] - 0.4 * square[hook(26, k)][hook(25, j)][hook(24, i + 1)]) * up1 - (1.4 * u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, 4)] - 0.4 * square[hook(26, k)][hook(25, j)][hook(24, i - 1)]) * um1);
  }

  i = 1;
  for (m = 0; m < 5; m++) {
    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (5.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, m)] - 4.0 * u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, m)] + u[hook(21, k)][hook(20, j)][hook(19, i + 2)][hook(39, m)]);
  }

  i = 2;
  for (m = 0; m < 5; m++) {
    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (-4.0 * u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, m)] + 6.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, m)] - 4.0 * u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, m)] + u[hook(21, k)][hook(20, j)][hook(19, i + 2)][hook(39, m)]);
  }

  for (i = 3; i <= nx2 - 2; i++) {
    for (m = 0; m < 5; m++) {
      rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(21, k)][hook(20, j)][hook(19, i - 2)][hook(40, m)] - 4.0 * u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, m)] + 6.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, m)] - 4.0 * u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, m)] + u[hook(21, k)][hook(20, j)][hook(19, i + 2)][hook(39, m)]);
    }
  }

  i = nx2 - 1;
  for (m = 0; m < 5; m++) {
    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(21, k)][hook(20, j)][hook(19, i - 2)][hook(40, m)] - 4.0 * u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, m)] + 6.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, m)] - 4.0 * u[hook(21, k)][hook(20, j)][hook(19, i + 1)][hook(18, m)]);
  }

  i = nx2;
  for (m = 0; m < 5; m++) {
    rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] = rhs[hook(17, k)][hook(16, j)][hook(15, i)][hook(14, m)] - (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))) * (u[hook(21, k)][hook(20, j)][hook(19, i - 2)][hook(40, m)] - 4.0 * u[hook(21, k)][hook(20, j)][hook(19, i - 1)][hook(23, m)] + 5.0 * u[hook(21, k)][hook(20, j)][hook(19, i)][hook(22, m)]);
  }
}