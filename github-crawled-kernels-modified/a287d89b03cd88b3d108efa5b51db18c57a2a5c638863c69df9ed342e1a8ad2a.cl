//{"cv":25,"g_cv":4,"g_lhs":6,"g_lhsm":8,"g_lhsp":7,"g_rho_i":1,"g_rhos":5,"g_rhs":3,"g_speed":2,"g_ws":0,"gp2":12,"lhs":14,"lhs[0]":13,"lhs[k1]":42,"lhs[k2]":46,"lhs[k]":30,"lhs[nz2 + 1]":19,"lhsm":18,"lhsm[0]":17,"lhsm[k1]":52,"lhsm[k2]":53,"lhsm[k]":37,"lhsm[nz2 + 1]":21,"lhsp":16,"lhsp[0]":15,"lhsp[k1]":50,"lhsp[k2]":51,"lhsp[k]":31,"lhsp[nz2 + 1]":20,"nx2":9,"ny2":10,"nz2":11,"rho_i":24,"rho_i[k]":23,"rho_i[k][j]":22,"rhos":29,"rhs":41,"rhs[k1]":45,"rhs[k1][j]":44,"rhs[k1][j][i]":43,"rhs[k2]":49,"rhs[k2][j]":48,"rhs[k2][j][i]":47,"rhs[k]":40,"rhs[k][j]":39,"rhs[k][j][i]":38,"speed":34,"speed[k + 1]":36,"speed[k + 1][j]":35,"speed[k - 1]":33,"speed[k - 1][j]":32,"ws":28,"ws[k]":27,"ws[k][j]":26}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void z_solve(global double* g_ws, global double* g_rho_i, global double* g_speed, global double* g_rhs, global double* g_cv, global double* g_rhos, global double* g_lhs, global double* g_lhsp, global double* g_lhsm, int nx2, int ny2, int nz2, int gp2) {
  int i, j, k, k1, k2, m;
  double ru1, fac1, fac2;

  j = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (j > ny2 || i > nx2)
    return;

  global double(*ws)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_ws;
  global double(*rho_i)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_rho_i;
  global double(*speed)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_speed;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  int my_id = (j - 1) * nx2 + (i - 1);
  int my_offset = my_id * 64;
  global double* cv = (global double*)&g_cv[hook(4, my_offset)];
  global double* rhos = (global double*)&g_rhos[hook(5, my_offset)];

  my_offset = my_id * ((64 / 2 * 2) + 1) * 5;
  global double(*lhs)[5] = (global double(*)[5]) & g_lhs[hook(6, my_offset)];
  global double(*lhsp)[5] = (global double(*)[5]) & g_lhsp[hook(7, my_offset)];
  global double(*lhsm)[5] = (global double(*)[5]) & g_lhsm[hook(8, my_offset)];

  for (m = 0; m < 5; m++) {
    lhs[hook(14, 0)][hook(13, m)] = 0.0;
    lhsp[hook(16, 0)][hook(15, m)] = 0.0;
    lhsm[hook(18, 0)][hook(17, m)] = 0.0;
    lhs[hook(14, nz2 + 1)][hook(19, m)] = 0.0;
    lhsp[hook(16, nz2 + 1)][hook(20, m)] = 0.0;
    lhsm[hook(18, nz2 + 1)][hook(21, m)] = 0.0;
  }
  lhs[hook(14, 0)][hook(13, 2)] = 1.0;
  lhsp[hook(16, 0)][hook(15, 2)] = 1.0;
  lhsm[hook(18, 0)][hook(17, 2)] = 1.0;
  lhs[hook(14, nz2 + 1)][hook(19, 2)] = 1.0;
  lhsp[hook(16, nz2 + 1)][hook(20, 2)] = 1.0;
  lhsm[hook(18, nz2 + 1)][hook(21, 2)] = 1.0;
  for (k = 0; k <= nz2 + 1; k++) {
    ru1 = (0.1 * 1.0) * rho_i[hook(24, k)][hook(23, j)][hook(22, i)];
    cv[hook(25, k)] = ws[hook(28, k)][hook(27, j)][hook(26, i)];
    rhos[hook(29, k)] = ((((1.0 + (4.0 / 3.0) * ru1) > (1.0 + (1.4 * 1.4) * ru1) ? (1.0 + (4.0 / 3.0) * ru1) : (1.0 + (1.4 * 1.4) * ru1))) > (((((1.0) > (1.0) ? (1.0) : (1.0)) + ru1) > (1.0) ? (((1.0) > (1.0) ? (1.0) : (1.0)) + ru1) : (1.0))) ? (((1.0 + (4.0 / 3.0) * ru1) > (1.0 + (1.4 * 1.4) * ru1) ? (1.0 + (4.0 / 3.0) * ru1) : (1.0 + (1.4 * 1.4) * ru1))) : (((((1.0) > (1.0) ? (1.0) : (1.0)) + ru1) > (1.0) ? (((1.0) > (1.0) ? (1.0) : (1.0)) + ru1) : (1.0))));
  }

  for (k = 1; k <= nz2; k++) {
    lhs[hook(14, k)][hook(30, 0)] = 0.0;
    lhs[hook(14, k)][hook(30, 1)] = -(0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * cv[hook(25, k - 1)] - (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * rhos[hook(29, k - 1)];
    lhs[hook(14, k)][hook(30, 2)] = 1.0 + (2.0 * (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1)))))) * rhos[hook(29, k)];
    lhs[hook(14, k)][hook(30, 3)] = (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * cv[hook(25, k + 1)] - (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * rhos[hook(29, k + 1)];
    lhs[hook(14, k)][hook(30, 4)] = 0.0;
  }

  k = 1;
  lhs[hook(14, k)][hook(30, 2)] = lhs[hook(14, k)][hook(30, 2)] + (5.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 3)] = lhs[hook(14, k)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 4)] = lhs[hook(14, k)][hook(30, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));

  k = 2;
  lhs[hook(14, k)][hook(30, 1)] = lhs[hook(14, k)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 2)] = lhs[hook(14, k)][hook(30, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 3)] = lhs[hook(14, k)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 4)] = lhs[hook(14, k)][hook(30, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));

  for (k = 3; k <= nz2 - 2; k++) {
    lhs[hook(14, k)][hook(30, 0)] = lhs[hook(14, k)][hook(30, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
    lhs[hook(14, k)][hook(30, 1)] = lhs[hook(14, k)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, k)][hook(30, 2)] = lhs[hook(14, k)][hook(30, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, k)][hook(30, 3)] = lhs[hook(14, k)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, k)][hook(30, 4)] = lhs[hook(14, k)][hook(30, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  }

  k = nz2 - 1;
  lhs[hook(14, k)][hook(30, 0)] = lhs[hook(14, k)][hook(30, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  lhs[hook(14, k)][hook(30, 1)] = lhs[hook(14, k)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 2)] = lhs[hook(14, k)][hook(30, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 3)] = lhs[hook(14, k)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));

  k = nz2;
  lhs[hook(14, k)][hook(30, 0)] = lhs[hook(14, k)][hook(30, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  lhs[hook(14, k)][hook(30, 1)] = lhs[hook(14, k)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, k)][hook(30, 2)] = lhs[hook(14, k)][hook(30, 2)] + (5.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));

  for (k = 1; k <= nz2; k++) {
    lhsp[hook(16, k)][hook(31, 0)] = lhs[hook(14, k)][hook(30, 0)];
    lhsp[hook(16, k)][hook(31, 1)] = lhs[hook(14, k)][hook(30, 1)] - (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(34, k - 1)][hook(33, j)][hook(32, i)];
    lhsp[hook(16, k)][hook(31, 2)] = lhs[hook(14, k)][hook(30, 2)];
    lhsp[hook(16, k)][hook(31, 3)] = lhs[hook(14, k)][hook(30, 3)] + (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(34, k + 1)][hook(36, j)][hook(35, i)];
    lhsp[hook(16, k)][hook(31, 4)] = lhs[hook(14, k)][hook(30, 4)];
    lhsm[hook(18, k)][hook(37, 0)] = lhs[hook(14, k)][hook(30, 0)];
    lhsm[hook(18, k)][hook(37, 1)] = lhs[hook(14, k)][hook(30, 1)] + (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(34, k - 1)][hook(33, j)][hook(32, i)];
    lhsm[hook(18, k)][hook(37, 2)] = lhs[hook(14, k)][hook(30, 2)];
    lhsm[hook(18, k)][hook(37, 3)] = lhs[hook(14, k)][hook(30, 3)] - (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(34, k + 1)][hook(36, j)][hook(35, i)];
    lhsm[hook(18, k)][hook(37, 4)] = lhs[hook(14, k)][hook(30, 4)];
  }

  for (k = 0; k <= gp2 - 3; k++) {
    k1 = k + 1;
    k2 = k + 2;

    fac1 = 1.0 / lhs[hook(14, k)][hook(30, 2)];
    lhs[hook(14, k)][hook(30, 3)] = fac1 * lhs[hook(14, k)][hook(30, 3)];
    lhs[hook(14, k)][hook(30, 4)] = fac1 * lhs[hook(14, k)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    }
    lhs[hook(14, k1)][hook(42, 2)] = lhs[hook(14, k1)][hook(42, 2)] - lhs[hook(14, k1)][hook(42, 1)] * lhs[hook(14, k)][hook(30, 3)];
    lhs[hook(14, k1)][hook(42, 3)] = lhs[hook(14, k1)][hook(42, 3)] - lhs[hook(14, k1)][hook(42, 1)] * lhs[hook(14, k)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] - lhs[hook(14, k1)][hook(42, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    }
    lhs[hook(14, k2)][hook(46, 1)] = lhs[hook(14, k2)][hook(46, 1)] - lhs[hook(14, k2)][hook(46, 0)] * lhs[hook(14, k)][hook(30, 3)];
    lhs[hook(14, k2)][hook(46, 2)] = lhs[hook(14, k2)][hook(46, 2)] - lhs[hook(14, k2)][hook(46, 0)] * lhs[hook(14, k)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, m)] = rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, m)] - lhs[hook(14, k2)][hook(46, 0)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    }
  }

  k = gp2 - 2;
  k1 = gp2 - 1;

  fac1 = 1.0 / lhs[hook(14, k)][hook(30, 2)];
  lhs[hook(14, k)][hook(30, 3)] = fac1 * lhs[hook(14, k)][hook(30, 3)];
  lhs[hook(14, k)][hook(30, 4)] = fac1 * lhs[hook(14, k)][hook(30, 4)];
  for (m = 0; m < 3; m++) {
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  }
  lhs[hook(14, k1)][hook(42, 2)] = lhs[hook(14, k1)][hook(42, 2)] - lhs[hook(14, k1)][hook(42, 1)] * lhs[hook(14, k)][hook(30, 3)];
  lhs[hook(14, k1)][hook(42, 3)] = lhs[hook(14, k1)][hook(42, 3)] - lhs[hook(14, k1)][hook(42, 1)] * lhs[hook(14, k)][hook(30, 4)];
  for (m = 0; m < 3; m++) {
    rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] - lhs[hook(14, k1)][hook(42, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  }

  fac2 = 1.0 / lhs[hook(14, k1)][hook(42, 2)];
  for (m = 0; m < 3; m++) {
    rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] = fac2 * rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)];
  }

  for (k = 0; k <= gp2 - 3; k++) {
    k1 = k + 1;
    k2 = k + 2;

    m = 3;
    fac1 = 1.0 / lhsp[hook(16, k)][hook(31, 2)];
    lhsp[hook(16, k)][hook(31, 3)] = fac1 * lhsp[hook(16, k)][hook(31, 3)];
    lhsp[hook(16, k)][hook(31, 4)] = fac1 * lhsp[hook(16, k)][hook(31, 4)];
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsp[hook(16, k1)][hook(50, 2)] = lhsp[hook(16, k1)][hook(50, 2)] - lhsp[hook(16, k1)][hook(50, 1)] * lhsp[hook(16, k)][hook(31, 3)];
    lhsp[hook(16, k1)][hook(50, 3)] = lhsp[hook(16, k1)][hook(50, 3)] - lhsp[hook(16, k1)][hook(50, 1)] * lhsp[hook(16, k)][hook(31, 4)];
    rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] - lhsp[hook(16, k1)][hook(50, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsp[hook(16, k2)][hook(51, 1)] = lhsp[hook(16, k2)][hook(51, 1)] - lhsp[hook(16, k2)][hook(51, 0)] * lhsp[hook(16, k)][hook(31, 3)];
    lhsp[hook(16, k2)][hook(51, 2)] = lhsp[hook(16, k2)][hook(51, 2)] - lhsp[hook(16, k2)][hook(51, 0)] * lhsp[hook(16, k)][hook(31, 4)];
    rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, m)] = rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, m)] - lhsp[hook(16, k2)][hook(51, 0)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];

    m = 4;
    fac1 = 1.0 / lhsm[hook(18, k)][hook(37, 2)];
    lhsm[hook(18, k)][hook(37, 3)] = fac1 * lhsm[hook(18, k)][hook(37, 3)];
    lhsm[hook(18, k)][hook(37, 4)] = fac1 * lhsm[hook(18, k)][hook(37, 4)];
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsm[hook(18, k1)][hook(52, 2)] = lhsm[hook(18, k1)][hook(52, 2)] - lhsm[hook(18, k1)][hook(52, 1)] * lhsm[hook(18, k)][hook(37, 3)];
    lhsm[hook(18, k1)][hook(52, 3)] = lhsm[hook(18, k1)][hook(52, 3)] - lhsm[hook(18, k1)][hook(52, 1)] * lhsm[hook(18, k)][hook(37, 4)];
    rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] - lhsm[hook(18, k1)][hook(52, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsm[hook(18, k2)][hook(53, 1)] = lhsm[hook(18, k2)][hook(53, 1)] - lhsm[hook(18, k2)][hook(53, 0)] * lhsm[hook(18, k)][hook(37, 3)];
    lhsm[hook(18, k2)][hook(53, 2)] = lhsm[hook(18, k2)][hook(53, 2)] - lhsm[hook(18, k2)][hook(53, 0)] * lhsm[hook(18, k)][hook(37, 4)];
    rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, m)] = rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, m)] - lhsm[hook(18, k2)][hook(53, 0)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  }

  k = gp2 - 2;
  k1 = gp2 - 1;

  m = 3;
  fac1 = 1.0 / lhsp[hook(16, k)][hook(31, 2)];
  lhsp[hook(16, k)][hook(31, 3)] = fac1 * lhsp[hook(16, k)][hook(31, 3)];
  lhsp[hook(16, k)][hook(31, 4)] = fac1 * lhsp[hook(16, k)][hook(31, 4)];
  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  lhsp[hook(16, k1)][hook(50, 2)] = lhsp[hook(16, k1)][hook(50, 2)] - lhsp[hook(16, k1)][hook(50, 1)] * lhsp[hook(16, k)][hook(31, 3)];
  lhsp[hook(16, k1)][hook(50, 3)] = lhsp[hook(16, k1)][hook(50, 3)] - lhsp[hook(16, k1)][hook(50, 1)] * lhsp[hook(16, k)][hook(31, 4)];
  rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] - lhsp[hook(16, k1)][hook(50, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];

  m = 4;
  fac1 = 1.0 / lhsm[hook(18, k)][hook(37, 2)];
  lhsm[hook(18, k)][hook(37, 3)] = fac1 * lhsm[hook(18, k)][hook(37, 3)];
  lhsm[hook(18, k)][hook(37, 4)] = fac1 * lhsm[hook(18, k)][hook(37, 4)];
  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  lhsm[hook(18, k1)][hook(52, 2)] = lhsm[hook(18, k1)][hook(52, 2)] - lhsm[hook(18, k1)][hook(52, 1)] * lhsm[hook(18, k)][hook(37, 3)];
  lhsm[hook(18, k1)][hook(52, 3)] = lhsm[hook(18, k1)][hook(52, 3)] - lhsm[hook(18, k1)][hook(52, 1)] * lhsm[hook(18, k)][hook(37, 4)];
  rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] - lhsm[hook(18, k1)][hook(52, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];

  rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 3)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 3)] / lhsp[hook(16, k1)][hook(50, 2)];
  rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 4)] = rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 4)] / lhsm[hook(18, k1)][hook(52, 2)];

  k = gp2 - 2;
  k1 = gp2 - 1;

  for (m = 0; m < 3; m++) {
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] - lhs[hook(14, k)][hook(30, 3)] * rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)];
  }

  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] - lhsp[hook(16, k)][hook(31, 3)] * rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 3)];
  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] - lhsm[hook(18, k)][hook(37, 3)] * rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 4)];
  for (k = gp2 - 3; k >= 0; k--) {
    k1 = k + 1;
    k2 = k + 2;

    for (m = 0; m < 3; m++) {
      rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] - lhs[hook(14, k)][hook(30, 3)] * rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, m)] - lhs[hook(14, k)][hook(30, 4)] * rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, m)];
    }

    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] - lhsp[hook(16, k)][hook(31, 3)] * rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 3)] - lhsp[hook(16, k)][hook(31, 4)] * rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, 3)];
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] - lhsm[hook(18, k)][hook(37, 3)] * rhs[hook(41, k1)][hook(45, j)][hook(44, i)][hook(43, 4)] - lhsm[hook(18, k)][hook(37, 4)] * rhs[hook(41, k2)][hook(49, j)][hook(48, i)][hook(47, 4)];
  }
}