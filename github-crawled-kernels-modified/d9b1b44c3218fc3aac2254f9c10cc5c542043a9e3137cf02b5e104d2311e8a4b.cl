//{"cv":25,"g_cv":4,"g_lhs":6,"g_lhsm":8,"g_lhsp":7,"g_rho_i":1,"g_rhoq":5,"g_rhs":3,"g_speed":2,"g_vs":0,"gp1":12,"lhs":14,"lhs[0]":13,"lhs[j + 1]":31,"lhs[j1]":42,"lhs[j2]":45,"lhs[j]":30,"lhs[ny2 + 1]":19,"lhsm":18,"lhsm[0]":17,"lhsm[j1]":50,"lhsm[j2]":51,"lhsm[j]":37,"lhsm[ny2 + 1]":21,"lhsp":16,"lhsp[0]":15,"lhsp[j1]":48,"lhsp[j2]":49,"lhsp[j]":32,"lhsp[ny2 + 1]":20,"nx2":9,"ny2":10,"nz2":11,"rho_i":24,"rho_i[k]":23,"rho_i[k][j]":22,"rhoq":29,"rhs":41,"rhs[k]":40,"rhs[k][j1]":44,"rhs[k][j1][i]":43,"rhs[k][j2]":47,"rhs[k][j2][i]":46,"rhs[k][j]":39,"rhs[k][j][i]":38,"speed":35,"speed[k]":34,"speed[k][j + 1]":36,"speed[k][j - 1]":33,"vs":28,"vs[k]":27,"vs[k][j]":26}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void y_solve(global double* g_vs, global double* g_rho_i, global double* g_speed, global double* g_rhs, global double* g_cv, global double* g_rhoq, global double* g_lhs, global double* g_lhsp, global double* g_lhsm, int nx2, int ny2, int nz2, int gp1) {
  int i, j, k, j1, j2, m;
  double ru1, fac1, fac2;

  k = get_global_id(1) + 1;
  i = get_global_id(0) + 1;
  if (k > nz2 || i > nx2)
    return;

  global double(*vs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_vs;
  global double(*rho_i)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_rho_i;
  global double(*speed)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_speed;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  int my_id = (k - 1) * nx2 + (i - 1);
  int my_offset = my_id * 64;
  global double* cv = (global double*)&g_cv[hook(4, my_offset)];
  global double* rhoq = (global double*)&g_rhoq[hook(5, my_offset)];

  my_offset = my_id * ((64 / 2 * 2) + 1) * 5;
  global double(*lhs)[5] = (global double(*)[5]) & g_lhs[hook(6, my_offset)];
  global double(*lhsp)[5] = (global double(*)[5]) & g_lhsp[hook(7, my_offset)];
  global double(*lhsm)[5] = (global double(*)[5]) & g_lhsm[hook(8, my_offset)];

  for (m = 0; m < 5; m++) {
    lhs[hook(14, 0)][hook(13, m)] = 0.0;
    lhsp[hook(16, 0)][hook(15, m)] = 0.0;
    lhsm[hook(18, 0)][hook(17, m)] = 0.0;
    lhs[hook(14, ny2 + 1)][hook(19, m)] = 0.0;
    lhsp[hook(16, ny2 + 1)][hook(20, m)] = 0.0;
    lhsm[hook(18, ny2 + 1)][hook(21, m)] = 0.0;
  }
  lhs[hook(14, 0)][hook(13, 2)] = 1.0;
  lhsp[hook(16, 0)][hook(15, 2)] = 1.0;
  lhsm[hook(18, 0)][hook(17, 2)] = 1.0;
  lhs[hook(14, ny2 + 1)][hook(19, 2)] = 1.0;
  lhsp[hook(16, ny2 + 1)][hook(20, 2)] = 1.0;
  lhsm[hook(18, ny2 + 1)][hook(21, 2)] = 1.0;
  for (j = 0; j < gp1; j++) {
    ru1 = (0.1 * 1.0) * rho_i[hook(24, k)][hook(23, j)][hook(22, i)];
    cv[hook(25, j)] = vs[hook(28, k)][hook(27, j)][hook(26, i)];
    rhoq[hook(29, j)] = ((((0.75 + (4.0 / 3.0) * ru1) > (0.75 + (1.4 * 1.4) * ru1) ? (0.75 + (4.0 / 3.0) * ru1) : (0.75 + (1.4 * 1.4) * ru1))) > (((((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) > (0.75) ? (((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) : (0.75))) ? (((0.75 + (4.0 / 3.0) * ru1) > (0.75 + (1.4 * 1.4) * ru1) ? (0.75 + (4.0 / 3.0) * ru1) : (0.75 + (1.4 * 1.4) * ru1))) : (((((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) > (0.75) ? (((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) : (0.75))));
  }

  for (j = 1; j <= gp1 - 2; j++) {
    lhs[hook(14, j)][hook(30, 0)] = 0.0;
    lhs[hook(14, j)][hook(30, 1)] = -(0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * cv[hook(25, j - 1)] - (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * rhoq[hook(29, j - 1)];
    lhs[hook(14, j)][hook(30, 2)] = 1.0 + (2.0 * (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1)))))) * rhoq[hook(29, j)];
    lhs[hook(14, j)][hook(30, 3)] = (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * cv[hook(25, j + 1)] - (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * rhoq[hook(29, j + 1)];
    lhs[hook(14, j)][hook(30, 4)] = 0.0;
  }

  j = 1;
  lhs[hook(14, j)][hook(30, 2)] = lhs[hook(14, j)][hook(30, 2)] + (5.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j)][hook(30, 3)] = lhs[hook(14, j)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j)][hook(30, 4)] = lhs[hook(14, j)][hook(30, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));

  lhs[hook(14, j + 1)][hook(31, 1)] = lhs[hook(14, j + 1)][hook(31, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j + 1)][hook(31, 2)] = lhs[hook(14, j + 1)][hook(31, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j + 1)][hook(31, 3)] = lhs[hook(14, j + 1)][hook(31, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j + 1)][hook(31, 4)] = lhs[hook(14, j + 1)][hook(31, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));

  for (j = 3; j <= gp1 - 4; j++) {
    lhs[hook(14, j)][hook(30, 0)] = lhs[hook(14, j)][hook(30, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
    lhs[hook(14, j)][hook(30, 1)] = lhs[hook(14, j)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, j)][hook(30, 2)] = lhs[hook(14, j)][hook(30, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, j)][hook(30, 3)] = lhs[hook(14, j)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, j)][hook(30, 4)] = lhs[hook(14, j)][hook(30, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  }

  j = gp1 - 3;
  lhs[hook(14, j)][hook(30, 0)] = lhs[hook(14, j)][hook(30, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  lhs[hook(14, j)][hook(30, 1)] = lhs[hook(14, j)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j)][hook(30, 2)] = lhs[hook(14, j)][hook(30, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j)][hook(30, 3)] = lhs[hook(14, j)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));

  lhs[hook(14, j + 1)][hook(31, 0)] = lhs[hook(14, j + 1)][hook(31, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  lhs[hook(14, j + 1)][hook(31, 1)] = lhs[hook(14, j + 1)][hook(31, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, j + 1)][hook(31, 2)] = lhs[hook(14, j + 1)][hook(31, 2)] + (5.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));

  for (j = 1; j <= gp1 - 2; j++) {
    lhsp[hook(16, j)][hook(32, 0)] = lhs[hook(14, j)][hook(30, 0)];
    lhsp[hook(16, j)][hook(32, 1)] = lhs[hook(14, j)][hook(30, 1)] - (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j - 1)][hook(33, i)];
    lhsp[hook(16, j)][hook(32, 2)] = lhs[hook(14, j)][hook(30, 2)];
    lhsp[hook(16, j)][hook(32, 3)] = lhs[hook(14, j)][hook(30, 3)] + (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j + 1)][hook(36, i)];
    lhsp[hook(16, j)][hook(32, 4)] = lhs[hook(14, j)][hook(30, 4)];
    lhsm[hook(18, j)][hook(37, 0)] = lhs[hook(14, j)][hook(30, 0)];
    lhsm[hook(18, j)][hook(37, 1)] = lhs[hook(14, j)][hook(30, 1)] + (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j - 1)][hook(33, i)];
    lhsm[hook(18, j)][hook(37, 2)] = lhs[hook(14, j)][hook(30, 2)];
    lhsm[hook(18, j)][hook(37, 3)] = lhs[hook(14, j)][hook(30, 3)] - (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j + 1)][hook(36, i)];
    lhsm[hook(18, j)][hook(37, 4)] = lhs[hook(14, j)][hook(30, 4)];
  }

  for (j = 0; j <= gp1 - 3; j++) {
    j1 = j + 1;
    j2 = j + 2;

    fac1 = 1.0 / lhs[hook(14, j)][hook(30, 2)];
    lhs[hook(14, j)][hook(30, 3)] = fac1 * lhs[hook(14, j)][hook(30, 3)];
    lhs[hook(14, j)][hook(30, 4)] = fac1 * lhs[hook(14, j)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    }
    lhs[hook(14, j1)][hook(42, 2)] = lhs[hook(14, j1)][hook(42, 2)] - lhs[hook(14, j1)][hook(42, 1)] * lhs[hook(14, j)][hook(30, 3)];
    lhs[hook(14, j1)][hook(42, 3)] = lhs[hook(14, j1)][hook(42, 3)] - lhs[hook(14, j1)][hook(42, 1)] * lhs[hook(14, j)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] - lhs[hook(14, j1)][hook(42, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    }
    lhs[hook(14, j2)][hook(45, 1)] = lhs[hook(14, j2)][hook(45, 1)] - lhs[hook(14, j2)][hook(45, 0)] * lhs[hook(14, j)][hook(30, 3)];
    lhs[hook(14, j2)][hook(45, 2)] = lhs[hook(14, j2)][hook(45, 2)] - lhs[hook(14, j2)][hook(45, 0)] * lhs[hook(14, j)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, m)] = rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, m)] - lhs[hook(14, j2)][hook(45, 0)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    }
  }

  j = gp1 - 2;
  j1 = gp1 - 1;

  fac1 = 1.0 / lhs[hook(14, j)][hook(30, 2)];
  lhs[hook(14, j)][hook(30, 3)] = fac1 * lhs[hook(14, j)][hook(30, 3)];
  lhs[hook(14, j)][hook(30, 4)] = fac1 * lhs[hook(14, j)][hook(30, 4)];
  for (m = 0; m < 3; m++) {
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  }
  lhs[hook(14, j1)][hook(42, 2)] = lhs[hook(14, j1)][hook(42, 2)] - lhs[hook(14, j1)][hook(42, 1)] * lhs[hook(14, j)][hook(30, 3)];
  lhs[hook(14, j1)][hook(42, 3)] = lhs[hook(14, j1)][hook(42, 3)] - lhs[hook(14, j1)][hook(42, 1)] * lhs[hook(14, j)][hook(30, 4)];
  for (m = 0; m < 3; m++) {
    rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] - lhs[hook(14, j1)][hook(42, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  }

  fac2 = 1.0 / lhs[hook(14, j1)][hook(42, 2)];
  for (m = 0; m < 3; m++) {
    rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] = fac2 * rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)];
  }

  for (j = 0; j <= gp1 - 3; j++) {
    j1 = j + 1;
    j2 = j + 2;

    m = 3;
    fac1 = 1.0 / lhsp[hook(16, j)][hook(32, 2)];
    lhsp[hook(16, j)][hook(32, 3)] = fac1 * lhsp[hook(16, j)][hook(32, 3)];
    lhsp[hook(16, j)][hook(32, 4)] = fac1 * lhsp[hook(16, j)][hook(32, 4)];
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsp[hook(16, j1)][hook(48, 2)] = lhsp[hook(16, j1)][hook(48, 2)] - lhsp[hook(16, j1)][hook(48, 1)] * lhsp[hook(16, j)][hook(32, 3)];
    lhsp[hook(16, j1)][hook(48, 3)] = lhsp[hook(16, j1)][hook(48, 3)] - lhsp[hook(16, j1)][hook(48, 1)] * lhsp[hook(16, j)][hook(32, 4)];
    rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] - lhsp[hook(16, j1)][hook(48, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsp[hook(16, j2)][hook(49, 1)] = lhsp[hook(16, j2)][hook(49, 1)] - lhsp[hook(16, j2)][hook(49, 0)] * lhsp[hook(16, j)][hook(32, 3)];
    lhsp[hook(16, j2)][hook(49, 2)] = lhsp[hook(16, j2)][hook(49, 2)] - lhsp[hook(16, j2)][hook(49, 0)] * lhsp[hook(16, j)][hook(32, 4)];
    rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, m)] = rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, m)] - lhsp[hook(16, j2)][hook(49, 0)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];

    m = 4;
    fac1 = 1.0 / lhsm[hook(18, j)][hook(37, 2)];
    lhsm[hook(18, j)][hook(37, 3)] = fac1 * lhsm[hook(18, j)][hook(37, 3)];
    lhsm[hook(18, j)][hook(37, 4)] = fac1 * lhsm[hook(18, j)][hook(37, 4)];
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsm[hook(18, j1)][hook(50, 2)] = lhsm[hook(18, j1)][hook(50, 2)] - lhsm[hook(18, j1)][hook(50, 1)] * lhsm[hook(18, j)][hook(37, 3)];
    lhsm[hook(18, j1)][hook(50, 3)] = lhsm[hook(18, j1)][hook(50, 3)] - lhsm[hook(18, j1)][hook(50, 1)] * lhsm[hook(18, j)][hook(37, 4)];
    rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] - lhsm[hook(18, j1)][hook(50, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
    lhsm[hook(18, j2)][hook(51, 1)] = lhsm[hook(18, j2)][hook(51, 1)] - lhsm[hook(18, j2)][hook(51, 0)] * lhsm[hook(18, j)][hook(37, 3)];
    lhsm[hook(18, j2)][hook(51, 2)] = lhsm[hook(18, j2)][hook(51, 2)] - lhsm[hook(18, j2)][hook(51, 0)] * lhsm[hook(18, j)][hook(37, 4)];
    rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, m)] = rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, m)] - lhsm[hook(18, j2)][hook(51, 0)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  }

  j = gp1 - 2;
  j1 = gp1 - 1;

  m = 3;
  fac1 = 1.0 / lhsp[hook(16, j)][hook(32, 2)];
  lhsp[hook(16, j)][hook(32, 3)] = fac1 * lhsp[hook(16, j)][hook(32, 3)];
  lhsp[hook(16, j)][hook(32, 4)] = fac1 * lhsp[hook(16, j)][hook(32, 4)];
  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  lhsp[hook(16, j1)][hook(48, 2)] = lhsp[hook(16, j1)][hook(48, 2)] - lhsp[hook(16, j1)][hook(48, 1)] * lhsp[hook(16, j)][hook(32, 3)];
  lhsp[hook(16, j1)][hook(48, 3)] = lhsp[hook(16, j1)][hook(48, 3)] - lhsp[hook(16, j1)][hook(48, 1)] * lhsp[hook(16, j)][hook(32, 4)];
  rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] - lhsp[hook(16, j1)][hook(48, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];

  m = 4;
  fac1 = 1.0 / lhsm[hook(18, j)][hook(37, 2)];
  lhsm[hook(18, j)][hook(37, 3)] = fac1 * lhsm[hook(18, j)][hook(37, 3)];
  lhsm[hook(18, j)][hook(37, 4)] = fac1 * lhsm[hook(18, j)][hook(37, 4)];
  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = fac1 * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];
  lhsm[hook(18, j1)][hook(50, 2)] = lhsm[hook(18, j1)][hook(50, 2)] - lhsm[hook(18, j1)][hook(50, 1)] * lhsm[hook(18, j)][hook(37, 3)];
  lhsm[hook(18, j1)][hook(50, 3)] = lhsm[hook(18, j1)][hook(50, 3)] - lhsm[hook(18, j1)][hook(50, 1)] * lhsm[hook(18, j)][hook(37, 4)];
  rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] - lhsm[hook(18, j1)][hook(50, 1)] * rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)];

  rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 3)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 3)] / lhsp[hook(16, j1)][hook(48, 2)];
  rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 4)] = rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 4)] / lhsm[hook(18, j1)][hook(50, 2)];

  j = gp1 - 2;
  j1 = gp1 - 1;

  for (m = 0; m < 3; m++) {
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] - lhs[hook(14, j)][hook(30, 3)] * rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)];
  }

  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] - lhsp[hook(16, j)][hook(32, 3)] * rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 3)];
  rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] - lhsm[hook(18, j)][hook(37, 3)] * rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 4)];

  for (j = gp1 - 3; j >= 0; j--) {
    j1 = j + 1;
    j2 = j + 2;
    for (m = 0; m < 3; m++) {
      rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, m)] - lhs[hook(14, j)][hook(30, 3)] * rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, m)] - lhs[hook(14, j)][hook(30, 4)] * rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, m)];
    }

    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 3)] - lhsp[hook(16, j)][hook(32, 3)] * rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 3)] - lhsp[hook(16, j)][hook(32, 4)] * rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, 3)];
    rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] = rhs[hook(41, k)][hook(40, j)][hook(39, i)][hook(38, 4)] - lhsm[hook(18, j)][hook(37, 3)] * rhs[hook(41, k)][hook(40, j1)][hook(44, i)][hook(43, 4)] - lhsm[hook(18, j)][hook(37, 4)] * rhs[hook(41, k)][hook(40, j2)][hook(47, i)][hook(46, 4)];
  }
}