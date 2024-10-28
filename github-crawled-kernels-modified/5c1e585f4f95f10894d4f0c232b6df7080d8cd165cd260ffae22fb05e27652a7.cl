//{"cv":25,"g_cv":4,"g_lhs":6,"g_lhsm":8,"g_lhsp":7,"g_rho_i":1,"g_rhon":5,"g_rhs":3,"g_speed":2,"g_us":0,"gp0":12,"lhs":14,"lhs[0]":13,"lhs[i + 1]":31,"lhs[i1]":41,"lhs[i2]":43,"lhs[i]":30,"lhs[nx2 + 1]":19,"lhsm":18,"lhsm[0]":17,"lhsm[i1]":47,"lhsm[i2]":48,"lhsm[i]":36,"lhsm[nx2 + 1]":21,"lhsp":16,"lhsp[0]":15,"lhsp[i1]":45,"lhsp[i2]":46,"lhsp[i]":32,"lhsp[nx2 + 1]":20,"nx2":9,"ny2":10,"nz2":11,"rho_i":24,"rho_i[k]":23,"rho_i[k][j]":22,"rhon":29,"rhs":40,"rhs[k]":39,"rhs[k][j]":38,"rhs[k][j][i1]":42,"rhs[k][j][i2]":44,"rhs[k][j][i]":37,"speed":35,"speed[k]":34,"speed[k][j]":33,"us":28,"us[k]":27,"us[k][j]":26}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void x_solve(global double* g_us, global double* g_rho_i, global double* g_speed, global double* g_rhs, global double* g_cv, global double* g_rhon, global double* g_lhs, global double* g_lhsp, global double* g_lhsm, int nx2, int ny2, int nz2, int gp0) {
  int i, j, k, i1, i2, m;
  double ru1, fac1, fac2;

  k = get_global_id(1) + 1;
  j = get_global_id(0) + 1;
  if (k > nz2 || j > ny2)
    return;

  global double(*us)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_us;
  global double(*rho_i)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_rho_i;
  global double(*speed)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1]) g_speed;
  global double(*rhs)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5] = (global double(*)[(64 / 2 * 2) + 1][(64 / 2 * 2) + 1][5]) g_rhs;

  int my_id = (k - 1) * ny2 + (j - 1);
  int my_offset = my_id * 64;
  global double* cv = (global double*)&g_cv[hook(4, my_offset)];
  global double* rhon = (global double*)&g_rhon[hook(5, my_offset)];

  my_offset = my_id * ((64 / 2 * 2) + 1) * 5;
  global double(*lhs)[5] = (global double(*)[5]) & g_lhs[hook(6, my_offset)];
  global double(*lhsp)[5] = (global double(*)[5]) & g_lhsp[hook(7, my_offset)];
  global double(*lhsm)[5] = (global double(*)[5]) & g_lhsm[hook(8, my_offset)];

  for (m = 0; m < 5; m++) {
    lhs[hook(14, 0)][hook(13, m)] = 0.0;
    lhsp[hook(16, 0)][hook(15, m)] = 0.0;
    lhsm[hook(18, 0)][hook(17, m)] = 0.0;
    lhs[hook(14, nx2 + 1)][hook(19, m)] = 0.0;
    lhsp[hook(16, nx2 + 1)][hook(20, m)] = 0.0;
    lhsm[hook(18, nx2 + 1)][hook(21, m)] = 0.0;
  }
  lhs[hook(14, 0)][hook(13, 2)] = 1.0;
  lhsp[hook(16, 0)][hook(15, 2)] = 1.0;
  lhsm[hook(18, 0)][hook(17, 2)] = 1.0;
  lhs[hook(14, nx2 + 1)][hook(19, 2)] = 1.0;
  lhsp[hook(16, nx2 + 1)][hook(20, 2)] = 1.0;
  lhsm[hook(18, nx2 + 1)][hook(21, 2)] = 1.0;
  for (i = 0; i < gp0; i++) {
    ru1 = (0.1 * 1.0) * rho_i[hook(24, k)][hook(23, j)][hook(22, i)];
    cv[hook(25, i)] = us[hook(28, k)][hook(27, j)][hook(26, i)];
    rhon[hook(29, i)] = ((((0.75 + (4.0 / 3.0) * ru1) > (0.75 + (1.4 * 1.4) * ru1) ? (0.75 + (4.0 / 3.0) * ru1) : (0.75 + (1.4 * 1.4) * ru1))) > (((((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) > (0.75) ? (((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) : (0.75))) ? (((0.75 + (4.0 / 3.0) * ru1) > (0.75 + (1.4 * 1.4) * ru1) ? (0.75 + (4.0 / 3.0) * ru1) : (0.75 + (1.4 * 1.4) * ru1))) : (((((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) > (0.75) ? (((0.75) > (0.75) ? (0.75) : (0.75)) + ru1) : (0.75))));
  }

  for (i = 1; i <= nx2; i++) {
    lhs[hook(14, i)][hook(30, 0)] = 0.0;
    lhs[hook(14, i)][hook(30, 1)] = -(0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * cv[hook(25, i - 1)] - (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * rhon[hook(29, i - 1)];
    lhs[hook(14, i)][hook(30, 2)] = 1.0 + (2.0 * (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1)))))) * rhon[hook(29, i)];
    lhs[hook(14, i)][hook(30, 3)] = (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * cv[hook(25, i + 1)] - (0.0015 * (1.0 / ((1.0 / (double)(64 - 1)) * (1.0 / (double)(64 - 1))))) * rhon[hook(29, i + 1)];
    lhs[hook(14, i)][hook(30, 4)] = 0.0;
  }

  i = 1;
  lhs[hook(14, i)][hook(30, 2)] = lhs[hook(14, i)][hook(30, 2)] + (5.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i)][hook(30, 3)] = lhs[hook(14, i)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i)][hook(30, 4)] = lhs[hook(14, i)][hook(30, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));

  lhs[hook(14, i + 1)][hook(31, 1)] = lhs[hook(14, i + 1)][hook(31, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i + 1)][hook(31, 2)] = lhs[hook(14, i + 1)][hook(31, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i + 1)][hook(31, 3)] = lhs[hook(14, i + 1)][hook(31, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i + 1)][hook(31, 4)] = lhs[hook(14, i + 1)][hook(31, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));

  for (i = 3; i <= gp0 - 4; i++) {
    lhs[hook(14, i)][hook(30, 0)] = lhs[hook(14, i)][hook(30, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
    lhs[hook(14, i)][hook(30, 1)] = lhs[hook(14, i)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, i)][hook(30, 2)] = lhs[hook(14, i)][hook(30, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, i)][hook(30, 3)] = lhs[hook(14, i)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
    lhs[hook(14, i)][hook(30, 4)] = lhs[hook(14, i)][hook(30, 4)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  }

  i = gp0 - 3;
  lhs[hook(14, i)][hook(30, 0)] = lhs[hook(14, i)][hook(30, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  lhs[hook(14, i)][hook(30, 1)] = lhs[hook(14, i)][hook(30, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i)][hook(30, 2)] = lhs[hook(14, i)][hook(30, 2)] + (6.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i)][hook(30, 3)] = lhs[hook(14, i)][hook(30, 3)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));

  lhs[hook(14, i + 1)][hook(31, 0)] = lhs[hook(14, i + 1)][hook(31, 0)] + (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0))))));
  lhs[hook(14, i + 1)][hook(31, 1)] = lhs[hook(14, i + 1)][hook(31, 1)] - (4.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));
  lhs[hook(14, i + 1)][hook(31, 2)] = lhs[hook(14, i + 1)][hook(31, 2)] + (5.0 * (0.0015 * (0.25 * ((0.75) > (((0.75) > (1.0) ? (0.75) : (1.0))) ? (0.75) : (((0.75) > (1.0) ? (0.75) : (1.0)))))));

  for (i = 1; i <= nx2; i++) {
    lhsp[hook(16, i)][hook(32, 0)] = lhs[hook(14, i)][hook(30, 0)];
    lhsp[hook(16, i)][hook(32, 1)] = lhs[hook(14, i)][hook(30, 1)] - (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j)][hook(33, i - 1)];
    lhsp[hook(16, i)][hook(32, 2)] = lhs[hook(14, i)][hook(30, 2)];
    lhsp[hook(16, i)][hook(32, 3)] = lhs[hook(14, i)][hook(30, 3)] + (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j)][hook(33, i + 1)];
    lhsp[hook(16, i)][hook(32, 4)] = lhs[hook(14, i)][hook(30, 4)];
    lhsm[hook(18, i)][hook(36, 0)] = lhs[hook(14, i)][hook(30, 0)];
    lhsm[hook(18, i)][hook(36, 1)] = lhs[hook(14, i)][hook(30, 1)] + (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j)][hook(33, i - 1)];
    lhsm[hook(18, i)][hook(36, 2)] = lhs[hook(14, i)][hook(30, 2)];
    lhsm[hook(18, i)][hook(36, 3)] = lhs[hook(14, i)][hook(30, 3)] - (0.0015 * (1.0 / (2.0 * (1.0 / (double)(64 - 1))))) * speed[hook(35, k)][hook(34, j)][hook(33, i + 1)];
    lhsm[hook(18, i)][hook(36, 4)] = lhs[hook(14, i)][hook(30, 4)];
  }
  for (i = 0; i <= gp0 - 3; i++) {
    i1 = i + 1;
    i2 = i + 2;
    fac1 = 1.0 / lhs[hook(14, i)][hook(30, 2)];
    lhs[hook(14, i)][hook(30, 3)] = fac1 * lhs[hook(14, i)][hook(30, 3)];
    lhs[hook(14, i)][hook(30, 4)] = fac1 * lhs[hook(14, i)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = fac1 * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
    }
    lhs[hook(14, i1)][hook(41, 2)] = lhs[hook(14, i1)][hook(41, 2)] - lhs[hook(14, i1)][hook(41, 1)] * lhs[hook(14, i)][hook(30, 3)];
    lhs[hook(14, i1)][hook(41, 3)] = lhs[hook(14, i1)][hook(41, 3)] - lhs[hook(14, i1)][hook(41, 1)] * lhs[hook(14, i)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] - lhs[hook(14, i1)][hook(41, 1)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
    }
    lhs[hook(14, i2)][hook(43, 1)] = lhs[hook(14, i2)][hook(43, 1)] - lhs[hook(14, i2)][hook(43, 0)] * lhs[hook(14, i)][hook(30, 3)];
    lhs[hook(14, i2)][hook(43, 2)] = lhs[hook(14, i2)][hook(43, 2)] - lhs[hook(14, i2)][hook(43, 0)] * lhs[hook(14, i)][hook(30, 4)];
    for (m = 0; m < 3; m++) {
      rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, m)] - lhs[hook(14, i2)][hook(43, 0)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
    }
  }

  i = gp0 - 2;
  i1 = gp0 - 1;
  fac1 = 1.0 / lhs[hook(14, i)][hook(30, 2)];
  lhs[hook(14, i)][hook(30, 3)] = fac1 * lhs[hook(14, i)][hook(30, 3)];
  lhs[hook(14, i)][hook(30, 4)] = fac1 * lhs[hook(14, i)][hook(30, 4)];
  for (m = 0; m < 3; m++) {
    rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = fac1 * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
  }
  lhs[hook(14, i1)][hook(41, 2)] = lhs[hook(14, i1)][hook(41, 2)] - lhs[hook(14, i1)][hook(41, 1)] * lhs[hook(14, i)][hook(30, 3)];
  lhs[hook(14, i1)][hook(41, 3)] = lhs[hook(14, i1)][hook(41, 3)] - lhs[hook(14, i1)][hook(41, 1)] * lhs[hook(14, i)][hook(30, 4)];
  for (m = 0; m < 3; m++) {
    rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] - lhs[hook(14, i1)][hook(41, 1)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
  }

  fac2 = 1.0 / lhs[hook(14, i1)][hook(41, 2)];
  for (m = 0; m < 3; m++) {
    rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] = fac2 * rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)];
  }

  for (i = 0; i <= gp0 - 3; i++) {
    i1 = i + 1;
    i2 = i + 2;

    m = 3;
    fac1 = 1.0 / lhsp[hook(16, i)][hook(32, 2)];
    lhsp[hook(16, i)][hook(32, 3)] = fac1 * lhsp[hook(16, i)][hook(32, 3)];
    lhsp[hook(16, i)][hook(32, 4)] = fac1 * lhsp[hook(16, i)][hook(32, 4)];
    rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = fac1 * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
    lhsp[hook(16, i1)][hook(45, 2)] = lhsp[hook(16, i1)][hook(45, 2)] - lhsp[hook(16, i1)][hook(45, 1)] * lhsp[hook(16, i)][hook(32, 3)];
    lhsp[hook(16, i1)][hook(45, 3)] = lhsp[hook(16, i1)][hook(45, 3)] - lhsp[hook(16, i1)][hook(45, 1)] * lhsp[hook(16, i)][hook(32, 4)];
    rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] - lhsp[hook(16, i1)][hook(45, 1)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
    lhsp[hook(16, i2)][hook(46, 1)] = lhsp[hook(16, i2)][hook(46, 1)] - lhsp[hook(16, i2)][hook(46, 0)] * lhsp[hook(16, i)][hook(32, 3)];
    lhsp[hook(16, i2)][hook(46, 2)] = lhsp[hook(16, i2)][hook(46, 2)] - lhsp[hook(16, i2)][hook(46, 0)] * lhsp[hook(16, i)][hook(32, 4)];
    rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, m)] - lhsp[hook(16, i2)][hook(46, 0)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];

    m = 4;
    fac1 = 1.0 / lhsm[hook(18, i)][hook(36, 2)];
    lhsm[hook(18, i)][hook(36, 3)] = fac1 * lhsm[hook(18, i)][hook(36, 3)];
    lhsm[hook(18, i)][hook(36, 4)] = fac1 * lhsm[hook(18, i)][hook(36, 4)];
    rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = fac1 * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
    lhsm[hook(18, i1)][hook(47, 2)] = lhsm[hook(18, i1)][hook(47, 2)] - lhsm[hook(18, i1)][hook(47, 1)] * lhsm[hook(18, i)][hook(36, 3)];
    lhsm[hook(18, i1)][hook(47, 3)] = lhsm[hook(18, i1)][hook(47, 3)] - lhsm[hook(18, i1)][hook(47, 1)] * lhsm[hook(18, i)][hook(36, 4)];
    rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] - lhsm[hook(18, i1)][hook(47, 1)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
    lhsm[hook(18, i2)][hook(48, 1)] = lhsm[hook(18, i2)][hook(48, 1)] - lhsm[hook(18, i2)][hook(48, 0)] * lhsm[hook(18, i)][hook(36, 3)];
    lhsm[hook(18, i2)][hook(48, 2)] = lhsm[hook(18, i2)][hook(48, 2)] - lhsm[hook(18, i2)][hook(48, 0)] * lhsm[hook(18, i)][hook(36, 4)];
    rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, m)] - lhsm[hook(18, i2)][hook(48, 0)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
  }

  i = gp0 - 2;
  i1 = gp0 - 1;

  m = 3;
  fac1 = 1.0 / lhsp[hook(16, i)][hook(32, 2)];
  lhsp[hook(16, i)][hook(32, 3)] = fac1 * lhsp[hook(16, i)][hook(32, 3)];
  lhsp[hook(16, i)][hook(32, 4)] = fac1 * lhsp[hook(16, i)][hook(32, 4)];
  rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = fac1 * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
  lhsp[hook(16, i1)][hook(45, 2)] = lhsp[hook(16, i1)][hook(45, 2)] - lhsp[hook(16, i1)][hook(45, 1)] * lhsp[hook(16, i)][hook(32, 3)];
  lhsp[hook(16, i1)][hook(45, 3)] = lhsp[hook(16, i1)][hook(45, 3)] - lhsp[hook(16, i1)][hook(45, 1)] * lhsp[hook(16, i)][hook(32, 4)];
  rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] - lhsp[hook(16, i1)][hook(45, 1)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];

  m = 4;
  fac1 = 1.0 / lhsm[hook(18, i)][hook(36, 2)];
  lhsm[hook(18, i)][hook(36, 3)] = fac1 * lhsm[hook(18, i)][hook(36, 3)];
  lhsm[hook(18, i)][hook(36, 4)] = fac1 * lhsm[hook(18, i)][hook(36, 4)];
  rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = fac1 * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];
  lhsm[hook(18, i1)][hook(47, 2)] = lhsm[hook(18, i1)][hook(47, 2)] - lhsm[hook(18, i1)][hook(47, 1)] * lhsm[hook(18, i)][hook(36, 3)];
  lhsm[hook(18, i1)][hook(47, 3)] = lhsm[hook(18, i1)][hook(47, 3)] - lhsm[hook(18, i1)][hook(47, 1)] * lhsm[hook(18, i)][hook(36, 4)];
  rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] - lhsm[hook(18, i1)][hook(47, 1)] * rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)];

  rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 3)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 3)] / lhsp[hook(16, i1)][hook(45, 2)];
  rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 4)] = rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 4)] / lhsm[hook(18, i1)][hook(47, 2)];

  i = gp0 - 2;
  i1 = gp0 - 1;
  for (m = 0; m < 3; m++) {
    rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] - lhs[hook(14, i)][hook(30, 3)] * rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)];
  }

  rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 3)] = rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 3)] - lhsp[hook(16, i)][hook(32, 3)] * rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 3)];
  rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 4)] = rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 4)] - lhsm[hook(18, i)][hook(36, 3)] * rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 4)];

  for (i = gp0 - 3; i >= 0; i--) {
    i1 = i + 1;
    i2 = i + 2;
    for (m = 0; m < 3; m++) {
      rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] = rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, m)] - lhs[hook(14, i)][hook(30, 3)] * rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, m)] - lhs[hook(14, i)][hook(30, 4)] * rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, m)];
    }

    rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 3)] = rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 3)] - lhsp[hook(16, i)][hook(32, 3)] * rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 3)] - lhsp[hook(16, i)][hook(32, 4)] * rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, 3)];
    rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 4)] = rhs[hook(40, k)][hook(39, j)][hook(38, i)][hook(37, 4)] - lhsm[hook(18, i)][hook(36, 3)] * rhs[hook(40, k)][hook(39, j)][hook(38, i1)][hook(42, 4)] - lhsm[hook(18, i)][hook(36, 4)] * rhs[hook(40, k)][hook(39, j)][hook(38, i2)][hook(44, 4)];
  }
}